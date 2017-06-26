require "ripper"

class Rufo::Formatter
  def self.format(code, **options)
    formatter = new(code, **options)
    formatter.format
    formatter.result
  end

  def initialize(code, **options)
    @code = code
    @tokens = Ripper.lex(code).reverse!
    @sexp = Ripper.sexp(code)

    unless @sexp
      raise ::Rufo::SyntaxError.new
    end

    @indent = 0
    @line = 0
    @column = 0
    @last_was_newline = false
    @output = ""

    # The column of a `obj.method` call, so we can align
    # calls to that dot
    @dot_column = nil

    # Heredocs list, associated with calls ([heredoc, tilde])
    @heredocs = []

    # Current node, to be able to associate it to heredocs
    @current_node = nil

    # The current heredoc being printed
    @current_heredoc = nil

    # The current hash or call or method that has hash-like parameters
    @current_hash = nil

    # Position of comments that occur at the end of a line
    @comments_positions = []

    # Associate lines to alignments
    # Associate a line to an index inside @comments_position
    # becuase when aligning something to the left of a comment
    # we need to adjust the relative comment
    @line_to_alignments_positions = Hash.new { |h, k| h[k] = [] }

    # Position of assignments
    @assignments_positions = []

    # Range of assignment (line => end_line)
    #
    # We need this because when we have to format:
    #
    # ```
    # abc = 1
    # a = foo bar: 2
    #         baz: #
    # ```
    #
    # Because we'll insert two spaces after `a`, this will
    # result in a mis-alignment for baz (and possibly other lines
    # below it). So, we remember the line ranges of an assignment,
    # and once we align the first one we fix the other ones.
    @assignments_ranges = {}

    # Hash keys positions
    @hash_keys_positions = []

    # Case when positions
    @case_when_positions = []

    # Settings
    indent_size options.fetch(:indent_size, 2)
    space_after_hash_brace options.fetch(:space_after_hash_brace, :dynamic)
    align_comments options.fetch(:align_comments, true)
    align_assignments options.fetch(:align_assignments, false)
    align_hash_keys options.fetch(:align_hash_keys, true)
    align_case_when options.fetch(:align_case_when, true)
    preserve_whitespace options.fetch(:preserve_whitespace, true)
  end

  # The indent size (default: 2)
  def indent_size(value)
    @indent_size = value
  end

  # Whether to put a space after a hash brace. Valid values are:
  #
  # * :dynamic: if there's a space, keep it. If not, don't keep it (default)
  # * :always: always put a space after a hash brace
  # * :never: never put a space after a hash brace
  def space_after_hash_brace(value)
    case value
    when :dynamic, :always, :never
      @space_after_hash_brace = value
    else
      raise ArgumentError.new("invalid value for #{space_after_hash_brace}: #{value}. Valid values are: :dynamic, :always, :never")
    end
  end

  # Whether to align successive comments (default: true)
  def align_comments(value)
    @align_comments = value
  end

  # Whether to align successive assignments (default: false)
  def align_assignments(value)
    @align_assignments = value
  end

  # Whether to align successive hash keys (default: true)
  def align_hash_keys(value)
    @align_hash_keys = value
  end

  # Whether to align successive case when (default: true)
  def align_case_when(value)
    @align_case_when = value
  end

  # Preserve whitespace after assignments target and values,
  # after calls that start with a space, hash arrows and commas.
  #
  # This allows for manual alignment of some code that would otherwise
  # be impossible to automatically format or preserve "beautiful".
  #
  # If `align_assignments` is true, this doesn't apply to assignments.
  # If `align_hash_keys` is true, this doesn't apply to hash keys.
  def preserve_whitespace(value)
    @preserve_whitespace = value
  end

  def format
    visit @sexp
    consume_end
    write_line unless @last_was_newline

    do_align_assignments if @align_assignments
    do_align_hash_keys if @align_hash_keys
    do_align_case_when if @align_case_when
    do_align_comments if @align_comments
  end

  def visit(node)
    unless node.is_a?(Array)
      bug "unexpected node: #{node} at #{current_token}"
    end

    case node.first
    when :program
      # Topmost node
      #
      # [:program, exps]
      visit_exps node[1]
    when :void_stmt
      # Empty statement
      #
      # [:void_stmt]
      skip_space_or_newline
    when :@int
      # Integer literal
      #
      # [:@int, "123", [1, 0]]
      consume_token :on_int
    when :@float
      # Float literal
      #
      # [:@int, "123.45", [1, 0]]
      consume_token :on_float
    when :@rational
      # Rational literal
      #
      # [:@rational, "123r", [1, 0]]
      consume_token :on_rational
    when :@imaginary
      # Imaginary literal
      #
      # [:@imaginary, "123i", [1, 0]]
      consume_token :on_imaginary
    when :@CHAR
      # [:@CHAR, "?a", [1, 0]]
      consume_token :on_CHAR
    when :@gvar
      # [:@gvar, "$abc", [1, 0]]
      write node[1]
      next_token
    when :@backref
      # [:@backref, "$1", [1, 0]]
      write node[1]
      next_token
    when :@backtick
      # [:@backtick, "`", [1, 4]]
      consume_token :on_backtick
    when :string_literal, :xstring_literal
      visit_string_literal node
    when :string_concat
      visit_string_concat node
    when :@tstring_content
      # [:@tstring_content, "hello ", [1, 1]]
      heredoc, tilde = @current_heredoc
      column = node[2][0]

      # For heredocs with tilde we sometimes need to align the contents
      if heredoc && tilde && @last_was_newline
        write_indent(next_indent)
        check :on_tstring_content
        consume_token_value(current_token_value)
        next_token
      else
        consume_token :on_tstring_content
      end
    when :string_content
      # [:string_content, exp]
      visit_exps node[1..-1], false, false
    when :string_embexpr
      # String interpolation piece ( #{exp} )
      visit_string_interpolation node
    when :string_dvar
      visit_string_dvar(node)
    when :symbol_literal
      visit_symbol_literal(node)
    when :symbol
      visit_symbol(node)
    when :dyna_symbol
      visit_quoted_symbol_literal(node)
    when :@ident
      consume_token :on_ident
    when :var_ref
      # [:var_ref, exp]
      visit node[1]
    when :var_field
      # [:var_field, exp]
      visit node[1]
    when :@kw
      # [:@kw, "nil", [1, 0]]
      consume_token :on_kw
    when :@ivar
      # [:@ivar, "@foo", [1, 0]]
      consume_token :on_ivar
    when :@cvar
      # [:@cvar, "@@foo", [1, 0]]
      consume_token :on_cvar
    when :@const
      # [:@const, "FOO", [1, 0]]
      consume_token :on_const
    when :const_ref
      # [:const_ref, [:@const, "Foo", [1, 8]]]
      visit node[1]
    when :top_const_ref
      # [:top_const_ref, [:@const, "Foo", [1, 2]]]
      consume_op "::"
      skip_space_or_newline
      visit node[1]
    when :top_const_field
      # [:top_const_field, [:@const, "Foo", [1, 2]]]
      consume_op "::"
      visit node[1]
    when :const_path_ref
      visit_path(node)
    when :const_path_field
      visit_path(node)
    when :assign
      visit_assign(node)
    when :opassign
      visit_op_assign(node)
    when :massign
      visit_multiple_assign(node)
    when :ifop
      visit_ternary_if(node)
    when :if_mod
      visit_suffix(node, "if")
    when :unless_mod
      visit_suffix(node, "unless")
    when :while_mod
      visit_suffix(node, "while")
    when :until_mod
      visit_suffix(node, "until")
    when :rescue_mod
      visit_suffix(node, "rescue")
    when :vcall
      # [:vcall, exp]
      visit node[1]
    when :fcall
      # [:fcall, [:@ident, "foo", [1, 0]]]
      visit node[1]
    when :command
      visit_command(node)
    when :command_call
      visit_command_call(node)
    when :args_add_block
      visit_call_args(node)
    when :args_add_star
      visit_args_add_star(node)
    when :bare_assoc_hash
      # [:bare_assoc_hash, exps]

      # Align hash elements to the first key
      indent(@column) do
        visit_comma_separated_list node[1]
      end
    when :method_add_arg
      visit_call_without_receiver(node)
    when :method_add_block
      visit_call_with_block(node)
    when :call
      visit_call_with_receiver(node)
    when :brace_block
      visit_brace_block(node)
    when :do_block
      visit_do_block(node)
    when :block_var
      visit_block_arguments(node)
    when :begin
      visit_begin(node)
    when :bodystmt
      visit_bodystmt(node)
    when :if
      visit_if(node)
    when :unless
      visit_unless(node)
    when :while
      visit_while(node)
    when :until
      visit_until(node)
    when :case
      visit_case(node)
    when :when
      visit_when(node)
    when :unary
      visit_unary(node)
    when :binary
      visit_binary(node)
    when :class
      visit_class(node)
    when :module
      visit_module(node)
    when :mrhs_new_from_args
      visit_mrhs_new_from_args(node)
    when :mlhs_paren
      visit_mlhs_paren(node)
    when :mrhs_add_star
      visit_mrhs_add_star(node)
    when :def
      visit_def(node)
    when :defs
      visit_def_with_receiver(node)
    when :paren
      visit_paren(node)
    when :params
      visit_params(node)
    when :array
      visit_array(node)
    when :hash
      visit_hash(node)
    when :assoc_new
      visit_hash_key_value(node)
    when :assoc_splat
      visit_splat_inside_hash(node)
    when :@label
      # [:@label, "foo:", [1, 3]]
      write node[1]
      next_token
    when :dot2
      visit_range(node, true)
    when :dot3
      visit_range(node, false)
    when :regexp_literal
      visit_regexp_literal(node)
    when :aref
      visit_array_access(node)
    when :aref_field
      visit_array_setter(node)
    when :sclass
      visit_sclass(node)
    when :field
      visit_setter(node)
    when :return0
      consume_keyword "return"
    when :return
      visit_return(node)
    when :break
      visit_break(node)
    when :next
      visit_next(node)
    when :yield0
      consume_keyword "yield"
    when :yield
      visit_yield(node)
    when :@op
      # [:@op, "*", [1, 1]]
      write node[1]
      next_token
    when :lambda
      visit_lambda(node)
    when :zsuper
      # [:zsuper]
      consume_keyword "super"
    when :super
      visit_super(node)
    when :defined
      visit_defined(node)
    when :alias, :var_alias
      visit_alias(node)
    when :undef
      visit_undef(node)
    when :mlhs_add_star
      visit_mlhs_add_star(node)
    when :retry
      # [:retry]
      consume_keyword "retry"
    when :redo
      # [:redo]
      consume_keyword "redo"
    when :for
      visit_for(node)
    when :BEGIN
      visit_BEGIN(node)
    when :END
      visit_END(node)
    else
      bug "Unhandled node: #{node.first}"
    end
  end

  def visit_exps(exps, with_indent = false, with_lines = true)
    consume_end_of_line(true)

    line_before_endline = nil

    exps.each_with_index do |exp, i|
      exp_kind = exp[0]

      # Skip voids to avoid extra indentation
      if exp_kind == :void_stmt
        next
      end

      if with_indent
        # Don't indent if this exp is in the same line as the previous
        # one (this happens when there's a semicolon between the exps)
        unless line_before_endline && line_before_endline == @line
          write_indent
        end
      end

      push_node(exp) do
        visit exp
      end

      is_last = last?(i, exps)

      skip_space unless is_last

      line_before_endline = @line

      if with_lines
        exp_needs_two_lines = needs_two_lines?(exp)

        consume_end_of_line(false, !is_last, !is_last, exp_needs_two_lines)

        # Make sure to put two lines before defs, class and others
        if !is_last && (exp_needs_two_lines || needs_two_lines?(exps[i + 1])) && @line <= line_before_endline + 1
          write_line
        end
      else
        skip_space_or_newline unless is_last
      end
    end
  end

  def needs_two_lines?(exp)
    kind = exp[0]
    case kind
    when :def, :class, :module
      return true
    when :vcall
      # Check if it's private/protected/public
      nested = exp[1]
      if nested[0] == :@ident
        case nested[1]
        when "private", "protected", "public"
          return true
        end
      end
    end

    false
  end

  def visit_string_literal(node)
    # [:string_literal, [:string_content, exps]]
    heredoc = current_token_kind == :on_heredoc_beg
    tilde = current_token_value.include?("~")

    if heredoc
      write current_token_value.rstrip
      # Accumulate heredoc: we'll write it once
      # we find a newline.
      @heredocs << [node, tilde]
      next_token
      return
    elsif current_token_kind == :on_backtick
      consume_token :on_backtick
    else
      consume_token :on_tstring_beg
    end

    visit_string_literal_end(node)
  end

  def visit_string_literal_end(node)
    inner = node[1]
    inner = inner[1..-1] unless node[0] == :xstring_literal
    visit_exps(inner, false, false)

    case current_token_kind
    when :on_heredoc_end
      heredoc, tilde = @current_heredoc
      if heredoc && tilde
        write_indent
        write current_token_value.strip
      else
        write current_token_value.rstrip
      end
      next_token
      skip_space

      # Simulate a newline after the heredoc
      @tokens << [[0, 0], :on_ignored_nl, "\n"]
    when :on_backtick
      consume_token :on_backtick
    else
      consume_token :on_tstring_end
    end
  end

  def visit_string_concat(node)
    # string1 string2
    # [:string_concat, string1, string2]
    _, string1, string2 = node

    visit string1

    has_backslash, first_space = skip_space_backslash
    if has_backslash
      write " \\"
      write_line
      write_indent
    else
      consume_space
    end

    visit string2
  end

  def visit_string_interpolation(node)
    # [:string_embexpr, exps]
    consume_token :on_embexpr_beg
    skip_space_or_newline
    visit_exps node[1], false, false
    skip_space_or_newline
    consume_token :on_embexpr_end
  end

  def visit_string_dvar(node)
    # [:string_dvar, [:var_ref, [:@ivar, "@foo", [1, 2]]]]
    consume_token :on_embvar
    visit node[1]
  end

  def visit_symbol_literal(node)
    # :foo
    #
    # [:symbol_literal, [:symbol, [:@ident, "foo", [1, 1]]]]
    #
    # A symbol literal not necessarily begins with `:`.
    # For example, an `alias foo bar` will treat `foo`
    # a as symbol_literal but without a `:symbol` child.
    visit node[1]
  end

  def visit_symbol(node)
    # :foo
    #
    # [:symbol, [:@ident, "foo", [1, 1]]]
    consume_token :on_symbeg
    visit_exps node[1..-1], false, false
  end

  def visit_quoted_symbol_literal(node)
    # :"foo"
    #
    # [:dyna_symbol, exps]
    _, exps = node

    # This is `"...":` as a hash key
    if current_token_kind == :on_tstring_beg
      consume_token :on_tstring_beg
      visit exps
      consume_token :on_label_end
    else
      consume_token :on_symbeg
      visit_exps exps, false, false
      consume_token :on_tstring_end
    end
  end

  def visit_path(node)
    # Foo::Bar
    #
    # [:const_path_ref,
    #   [:var_ref, [:@const, "Foo", [1, 0]]],
    #   [:@const, "Bar", [1, 5]]]
    pieces = node[1..-1]
    pieces.each_with_index do |piece, i|
      visit piece
      unless last?(i, pieces)
        consume_op "::"
        skip_space_or_newline
      end
    end
  end

  def visit_assign(node)
    # target = value
    #
    # [:assign, target, value]
    _, target, value = node

    line = @line

    visit target
    consume_space(!@align_assignments)
    track_assignment
    consume_op "="
    visit_assign_value value

    @assignments_ranges[line] = @line if @line != line
  end

  def visit_op_assign(node)
    # target += value
    #
    # [:opassign, target, op, value]
    _, target, op, value = node

    line = @line

    visit target
    consume_space(!@align_assignments)

    # [:@op, "+=", [1, 2]],
    check :on_op

    before = op[1][0...-1]
    after = op[1][-1]

    write before
    track_assignment before.size
    write after
    next_token

    visit_assign_value value

    @assignments_ranges[line] = @line if @line != line
  end

  def visit_multiple_assign(node)
    # [:massign, lefts, right]
    _, lefts, right = node

    visit_comma_separated_list lefts
    skip_space

    # A trailing comma can come after the left hand side
    consume_token :on_comma if comma?

    consume_space(!@align_assignments)
    track_assignment
    consume_op "="
    visit_assign_value right
  end

  def visit_assign_value(value)
    first_space = current_token if space?
    skip_space

    indent_after_space value, indentable_value?(value), true, first_space
  end

  def indentable_value?(value)
    return unless current_token_kind == :on_kw

    case current_token_value
    when "if", "unless", "case"
      true
    when "begin"
      # Only indent if it's begin/rescue
      return false unless value[0] == :begin

      body = value[1]
      return false unless body[0] == :bodystmt

      _, body, rescue_body, else_body, ensure_body = body
      rescue_body || else_body || ensure_body
    else
      false
    end
  end

  def track_comment
    @line_to_alignments_positions[@line] << [:comment, @column, @comments_positions, @comments_positions.size]
    @comments_positions << [@line, @column, 0, nil, 0]
  end

  def track_assignment(offset = 0)
    track_alignment :assign, @assignments_positions, offset
  end

  def track_hash_key
    return unless @current_hash

    track_alignment :hash_key, @hash_keys_positions, 0, @current_hash.object_id
  end

  def track_case_when
    track_alignment :case_whem, @case_when_positions
  end

  def track_alignment(key, target, offset = 0, id = nil)
    last = target.last
    if last && last[0] == @line
      # Track only the first alignment in a line
      return
    end

    @line_to_alignments_positions[@line] << [key, @column, target, target.size]
    target << [@line, @column, @indent, id, offset]
  end

  def visit_ternary_if(node)
    # cond ? then : else
    #
    # [:ifop, cond, then_body, else_body]
    _, cond, then_body, else_body = node

    visit cond
    consume_space(true)
    consume_op "?"

    first_space = current_token if space?

    skip_space
    if newline? || comment?
      consume_end_of_line
      write_indent(next_indent)
    elsif first_space && @preserve_whitespace
      write_space first_space[2]
    else
      consume_space
    end

    visit then_body
    consume_space(true)
    consume_op ":"

    first_space = current_token if space?
    skip_space

    if newline? || comment?
      consume_end_of_line
      write_indent(next_indent)
    elsif first_space && @preserve_whitespace
      write_space first_space[2]
    else
      consume_space
    end

    visit else_body
  end

  def visit_suffix(node, suffix)
    # then if cond
    # then unless cond
    # exp rescue handler
    #
    # [:if_mod, cond, body]
    _, body, cond = node

    if suffix != "rescue"
      body, cond = cond, body
    end

    visit body

    consume_space(true)
    consume_keyword(suffix)
    consume_space(true)
    visit cond
  end

  def visit_call_with_receiver(node)
    # [:call, obj, :".", call]
    _, obj, text, call = node

    @dot_column = nil
    visit obj

    skip_space

    if newline? || comment?
      consume_end_of_line

      write_indent(@dot_column || next_indent)
    end

    # Remember dot column
    dot_column = @column
    consume_call_dot

    skip_space

    if newline? || comment?
      consume_end_of_line
      write_indent(next_indent)
    else
      skip_space_or_newline
    end

    if call == :call
      # :call means it's .()
    else
      visit call
    end

    # Only set it after we visit the call after the dot,
    # so we remember the outmost dot position
    @dot_column = dot_column
  end

  def consume_call_dot
    if current_token_kind == :on_op
      consume_token :on_op
    else
      check :on_period
      next_token
      write "."
    end
  end

  def visit_call_without_receiver(node)
    # foo(arg1, ..., argN)
    #
    # [:method_add_arg,
    #   [:fcall, [:@ident, "foo", [1, 0]]],
    #   [:arg_paren, [:args_add_block, [[:@int, "1", [1, 6]]], false]]]
    _, name, args = node

    visit name

    # Some times a call comes without parens (should probably come as command, but well...)
    return if args.empty?

    # Remember dot column so it's not affected by args
    dot_column = @dot_column

    visit_call_at_paren(node, args)

    # Restore dot column so it's not affected by args
    @dot_column = dot_column
  end

  def visit_call_at_paren(node, args)
    consume_token :on_lparen

    # If there's a trailing comma then comes [:arg_paren, args],
    # which is a bit unexpected, so we fix it
    if args[1].is_a?(Array) && args[1][0].is_a?(Array)
      args_node = [:args_add_block, args[1], false]
    else
      args_node = args[1]
    end

    if args_node
      skip_space

      needs_trailing_newline = newline? || comment?

      push_call(node) do
        visit args_node
        skip_space
      end

      found_comma = comma?

      if found_comma
        if needs_trailing_newline
          write ","
          next_token
          indent(next_indent) do
            consume_end_of_line
          end
          write_indent
        else
          next_token
          skip_space
        end
      end

      if newline? || comment?
        if needs_trailing_newline
          indent(next_indent) do
            consume_end_of_line
          end
          write_indent
        else
          skip_space_or_newline
        end
      else
        if needs_trailing_newline && !found_comma
          consume_end_of_line
          write_indent
        end
      end
    else
      skip_space_or_newline
    end

    consume_token :on_rparen
  end

  def visit_command(node)
    # foo arg1, ..., argN
    #
    # [:command, name, args]
    _, name, args = node

    push_call(node) do
      visit name

      has_backslash, first_space = skip_space_backslash
      if has_backslash
        write " \\"
        write_line
        write_indent(next_indent)
      elsif first_space && @preserve_whitespace
        write_space first_space[2]
        skip_space_or_newline
      else
        consume_space
      end
    end

    visit_command_end(node, args)
  end

  def visit_command_end(node, args)
    push_call(node) do
      visit_command_args(args)
    end
  end

  def flush_heredocs
    printed = false

    until @heredocs.empty?
      heredoc, tilde = @heredocs.first

      @heredocs.shift
      @current_heredoc = [heredoc, tilde]
      visit_string_literal_end(heredoc)
      @current_heredoc = nil
      printed = true
    end
  end

  def visit_command_call(node)
    # [:command_call,
    #   receiver
    #   :".",
    #   name
    #   [:args_add_block, [[:@int, "1", [1, 8]]], block]]
    _, receiver, dot, name, args = node

    visit receiver
    skip_space_or_newline

    # Remember dot column
    dot_column = @column
    consume_call_dot

    skip_space

    if newline? || comment?
      consume_end_of_line
      write_indent(next_indent)
    else
      skip_space_or_newline
    end

    visit name
    consume_space

    visit_command_args(args)

    # Only set it after we visit the call after the dot,
    # so we remember the outmost dot position
    @dot_column = dot_column
  end

  def visit_command_args(args)
    needed_indent = @column

    # Check if there's a single argument and it's
    # a def, class or module. In that case we don't
    # want to align the content to the position of
    # that keyword.
    if args[0] == :args_add_block
      nested_args = args[1]
      if nested_args.is_a?(Array) && nested_args.size == 1
        first = nested_args[0]
        if first.is_a?(Array)
          case first[0]
          when :def, :class, :module
            needed_indent = @indent
          end
        end
      end
    end

    indent(needed_indent) do
      if args[0].is_a?(Symbol)
        visit args
      else
        visit_exps args, false, false
      end
    end
  end

  def visit_call_with_block(node)
    # [:method_add_block, call, block]
    _, call, block = node

    visit call

    consume_space
    visit block
  end

  def visit_brace_block(node)
    # [:brace_block, args, body]
    _, args, body = node

    # This is for the empty `{ }` block
    if void_exps?(body)
      consume_token :on_lbrace
      consume_block_args args
      consume_space
      consume_token :on_rbrace
      return
    end

    closing_brace_token, index = find_closing_brace_token

    # If the whole block fits into a single line, use braces
    if current_token[0][0] == closing_brace_token[0][0]
      consume_token :on_lbrace

      consume_block_args args

      consume_space
      visit_exps body, false, false
      consume_space

      consume_token :on_rbrace
      return
    end

    # Otherwise it's multiline
    consume_token :on_lbrace
    consume_block_args args
    indent_body body
    write_indent
    consume_token :on_rbrace
  end

  def visit_do_block(node)
    # [:brace_block, args, body]
    _, args, body = node

    consume_keyword "do"

    consume_block_args args

    indent_body body

    write_indent
    consume_keyword "end"
  end

  def consume_block_args(args)
    if args
      consume_space
      # + 1 because of |...|
      #                ^
      indent(@column + 1) do
        visit args
      end
    end
  end

  def visit_block_arguments(node)
    # [:block_var, params, local_params]
    _, params, local_params = node

    empty_params = empty_params?(params)

    check :on_op

    # check for ||
    if empty_params && !local_params
      # Don't write || as it's meaningless
      if current_token_value == "|"
        next_token
        skip_space_or_newline
        check :on_op
        next_token
      else
        next_token
      end
      return
    end

    consume_token :on_op
    found_semicolon = skip_space_or_newline(true, true)

    if found_semicolon
      # Nothing
    elsif empty_params && local_params
      consume_token :on_semicolon
      found_semicolon = true
    end

    skip_space_or_newline

    unless empty_params
      visit params
      skip_space
    end

    if local_params
      if semicolon?
        consume_token :on_semicolon
        consume_space
      end

      visit_comma_separated_list local_params
    else
      skip_space_or_newline
    end

    consume_op "|"
  end

  def visit_call_args(node)
    # [:args_add_block, args, block]
    _, args, block_arg = node

    if !args.empty? && args[0] == :args_add_star
      # arg1, ..., *star
      visit args
    else
      visit_comma_separated_list args
    end

    if block_arg
      skip_space_or_newline
      write_params_comma if comma?

      consume_op "&"
      visit block_arg
    end
  end

  def visit_args_add_star(node)
    # [:args_add_star, args, star, post_args]
    _, args, star, *post_args = node

    if !args.empty? && args[0] == :args_add_star
      # arg1, ..., *star
      visit args
    else
      visit_comma_separated_list args
    end

    skip_space

    write_params_comma if comma?

    consume_op "*"
    skip_space_or_newline
    visit star

    if post_args && !post_args.empty?
      write_params_comma
      visit_comma_separated_list post_args
    end
  end

  def visit_begin(node)
    # begin
    #   body
    # end
    #
    # [:begin, [:bodystmt, body, rescue_body, else_body, ensure_body]]
    consume_keyword "begin"
    visit node[1]
  end

  def visit_bodystmt(node)
    # [:bodystmt, body, rescue_body, else_body, ensure_body]
    _, body, rescue_body, else_body, ensure_body = node
    indent_body body

    while rescue_body
      # [:rescue, type, name, body, more_rescue]
      _, type, name, body, more_rescue = rescue_body
      write_indent
      consume_keyword "rescue"
      if type
        skip_space
        write_space
        indent(@column) do
          visit_rescue_types(type)
        end
      end

      if name
        skip_space
        write_space
        consume_op "=>"
        skip_space
        write_space
        visit name
      end

      indent_body body
      rescue_body = more_rescue
    end

    if else_body
      # [:else, body]
      write_indent
      consume_keyword "else"
      indent_body else_body[1]
    end

    if ensure_body
      # [:ensure, body]
      write_indent
      consume_keyword "ensure"
      indent_body ensure_body[1]
    end

    write_indent
    consume_keyword "end"
  end

  def visit_rescue_types(node)
    if node[0].is_a?(Symbol)
      visit node
    else
      visit_exps node, false, false
    end
  end

  def visit_mrhs_new_from_args(node)
    # Multiple exception types
    # [:mrhs_new_from_args, exps, final_exp]
    _, exps, final_exp = node

    if final_exp
      visit_comma_separated_list exps
      write_params_comma
      visit final_exp
    elsif exps[0].is_a?(Symbol)
      visit exps
    else
      visit_comma_separated_list exps
    end
  end

  def visit_mlhs_paren(node)
    # [:mlhs_paren,
    #   [[:mlhs_paren, [:@ident, "x", [1, 12]]]]
    # ]
    _, args = node

    # For some reason there's nested :mlhs_paren for
    # a single parentheses. It seems when there's
    # a nested array we need parens, otherwise we
    # just output whatever's inside `args`.
    if args.is_a?(Array) && args[0].is_a?(Array)
      check :on_lparen
      write "("
      next_token
      skip_space_or_newline

      indent(@column) do
        visit_comma_separated_list args
        skip_space_or_newline
      end

      check :on_rparen
      write ")"
      next_token
    else
      visit args
    end
  end

  def visit_mrhs_add_star(node)
    # [:mrhs_add_star, [], [:vcall, [:@ident, "x", [3, 8]]]]
    _, x, y = node

    if x.empty?
      consume_op "*"
      visit y
    else
      visit x
      write_params_comma
      consume_space
      consume_op "*"
      visit y
    end
  end

  def visit_for(node)
    #[:for, var, collection, body]
    _, var, collection, body = node

    consume_keyword "for"
    consume_space

    if var[0].is_a?(Symbol)
      visit var
    else
      visit_comma_separated_list var
    end

    consume_space
    consume_keyword "in"
    consume_space
    visit collection
    skip_space

    next_token if keyword?("do")

    indent_body body
    write_indent
    consume_keyword "end"
  end

  def visit_BEGIN(node)
    visit_BEGIN_or_END node, "BEGIN"
  end

  def visit_END(node)
    visit_BEGIN_or_END node, "END"
  end

  def visit_BEGIN_or_END(node, keyword)
    # [:BEGIN, body]
    _, body = node

    consume_keyword(keyword)
    consume_space

    closing_brace_token, _index = find_closing_brace_token

    # If the whole block fits into a single line, format
    # in a single line
    if current_token[0][0] == closing_brace_token[0][0]
      consume_token :on_lbrace
      consume_space
      visit_exps body, false, false
      consume_space
      consume_token :on_rbrace
    else
      consume_token :on_lbrace
      indent_body body
      write_indent
      consume_token :on_rbrace
    end
  end

  def visit_comma_separated_list(nodes)
    # When there's *x inside a left hand side assignment
    # or a case when, it comes as [:op, ...]
    if nodes[0].is_a?(Symbol)
      visit nodes
      return
    end

    needs_indent = false

    if newline? || comment?
      needs_indent = true
      base_column = next_indent
      consume_end_of_line
      write_indent(base_column)
    else
      base_column = @column
    end

    nodes.each_with_index do |exp, i|
      maybe_indent(needs_indent, base_column) do
        if block_given?
          yield exp
        else
          visit exp
        end
      end

      next if last?(i, nodes)

      skip_space
      check :on_comma
      write ","
      next_token

      first_space = current_token if space?
      skip_space

      if newline? || comment?
        indent(base_column || @indent) do
          consume_end_of_line(false, false, false)
          write_indent
        end
      elsif first_space && @preserve_whitespace
        write_space first_space[2]
        skip_space_or_newline
      else
        write_space
        skip_space_or_newline
      end
    end
  end

  def visit_mlhs_add_star(node)
    # [:mlhs_add_star, before, star, after]
    _, before, star, after = node

    if before && !before.empty?
      visit_comma_separated_list before
      write_params_comma
    end

    consume_op "*"
    skip_space_or_newline

    visit star if star

    if after && !after.empty?
      write_params_comma
      visit_comma_separated_list after
    end
  end

  def visit_unary(node)
    # [:unary, :-@, [:vcall, [:@ident, "x", [1, 2]]]]
    _, op, exp = node

    consume_op_or_keyword op

    if op == :not
      consume_space(true)
    else
      skip_space_or_newline
    end

    visit exp
  end

  def visit_binary(node)
    # [:binary, left, op, right]
    _, left, op, right = node

    visit left
    if space?
      needs_space = true
    else
      needs_space = op != :* && op != :/ && op != :**
    end

    has_backslash, first_space = skip_space_backslash
    if has_backslash
      needs_space = true
      write " \\"
      write_line
      write_indent(next_indent)
    elsif @preserve_whitespace && first_space
      write_space first_space[2]
    else
      write_space if needs_space
    end

    consume_op_or_keyword op
    indent_after_space right, false, needs_space
  end

  def consume_op_or_keyword(op)
    case current_token_kind
    when :on_op, :on_kw
      write current_token_value
      next_token
    else
      bug "Expected op or kw, not #{current_token_kind}"
    end
  end

  def visit_class(node)
    # [:class,
    #   name
    #   superclass
    #   [:bodystmt, body, nil, nil, nil]]
    _, name, superclass, body = node

    consume_keyword "class"
    skip_space_or_newline
    write_space
    visit name

    if superclass
      skip_space_or_newline
      write_space
      consume_op "<"
      skip_space_or_newline
      write_space
      visit superclass
    end

    maybe_inline_body body
  end

  def visit_module(node)
    # [:module,
    #   name
    #   [:bodystmt, body, nil, nil, nil]]
    _, name, body = node

    consume_keyword "module"
    skip_space_or_newline
    write_space
    visit name
    maybe_inline_body body
  end

  def maybe_inline_body(body)
    skip_space
    if semicolon? && empty_body?(body)
      next_token
      skip_space
      if newline?
        skip_space_or_newline
        visit body
      else
        write "; "
        skip_space_or_newline
        consume_keyword "end"
      end
    else
      visit body
    end
  end

  def visit_def(node)
    # [:def,
    #   [:@ident, "foo", [1, 6]],
    #   [:params, nil, nil, nil, nil, nil, nil, nil],
    #   [:bodystmt, [[:void_stmt]], nil, nil, nil]]
    _, name, params, body = node

    consume_keyword "def"
    consume_space

    push_hash(node) do
      visit_def_from_name name, params, body
    end
  end

  def visit_def_with_receiver(node)
    # [:defs,
    # [:vcall, [:@ident, "foo", [1, 5]]],
    # [:@period, ".", [1, 8]],
    # [:@ident, "bar", [1, 9]],
    # [:params, nil, nil, nil, nil, nil, nil, nil],
    # [:bodystmt, [[:void_stmt]], nil, nil, nil]]
    _, receiver, period, name, params, body = node

    consume_keyword "def"
    consume_space
    visit receiver
    skip_space_or_newline

    check :on_period
    write "."
    next_token
    skip_space_or_newline

    push_hash(node) do
      visit_def_from_name name, params, body
    end
  end

  def visit_def_from_name(name, params, body)
    visit name

    if params[0] == :paren
      params = params[1]
    end

    skip_space
    if current_token_kind == :on_lparen
      next_token
      skip_space
      skip_semicolons

      if empty_params?(params)
        skip_space_or_newline
        check :on_rparen
        next_token
        skip_space_or_newline
      else
        write "("

        if newline? || comment?
          column = @column
          indent(column) do
            consume_end_of_line
            write_indent
            visit params
          end
        else
          indent(@column) do
            visit params
          end
        end

        skip_space_or_newline
        check :on_rparen
        write ")"
        next_token
      end
    elsif !empty_params?(params)
      write "("
      visit params
      write ")"
      skip_space_or_newline
    end

    visit body
  end

  def empty_params?(node)
    _, a, b, c, d, e, f, g = node
    !a && !b && !c && !d && !e && !f && !g
  end

  def visit_paren(node)
    # ( exps )
    #
    # [:paren, exps]
    check :on_lparen
    write "("
    next_token
    skip_space_or_newline

    if node[1][0].is_a?(Symbol)
      visit node[1]
    else
      visit_exps node[1], false, false
    end

    skip_space_or_newline
    check :on_rparen
    write ")"
    next_token
  end

  def visit_params(node)
    # (def params)
    #
    # [:params, pre_rest_params, args_with_default, rest_param, post_rest_params, label_params, double_star_param, blockarg]
    _, pre_rest_params, args_with_default, rest_param, post_rest_params, label_params, double_star_param, blockarg = node

    needs_comma = false

    if pre_rest_params
      visit_comma_separated_list pre_rest_params
      needs_comma = true
    end

    if args_with_default
      write_params_comma if needs_comma
      visit_comma_separated_list(args_with_default) do |arg, default|
        visit arg
        skip_space
        write_space
        consume_op "="
        skip_space_or_newline
        write_space
        visit default
      end
      needs_comma = true
    end

    if rest_param
      # check for trailing , |x, |
      if rest_param == 0
        write_params_comma
      else
        # [:rest_param, [:@ident, "x", [1, 15]]]
        _, rest = rest_param
        write_params_comma if needs_comma
        consume_op "*"
        skip_space_or_newline
        visit rest if rest
        needs_comma = true
      end
    end

    if post_rest_params
      write_params_comma if needs_comma
      visit_comma_separated_list post_rest_params
      needs_comma = true
    end

    if label_params
      # [[label, value], ...]
      write_params_comma if needs_comma
      visit_comma_separated_list(label_params) do |label, value|
        # [:@label, "b:", [1, 20]]
        write label[1]
        next_token
        skip_space_or_newline
        if value
          consume_space
          track_hash_key
          visit value
        end
      end
      needs_comma = true
    end

    if double_star_param
      write_params_comma if needs_comma
      consume_op "**"
      skip_space_or_newline

      # A nameless double star comes as an... Integer? :-S
      visit double_star_param if double_star_param.is_a?(Array)
      skip_space_or_newline
      needs_comma = true
    end

    if blockarg
      # [:blockarg, [:@ident, "block", [1, 16]]]
      write_params_comma if needs_comma
      skip_space_or_newline
      consume_op "&"
      skip_space_or_newline
      visit blockarg[1]
    end
  end

  def write_params_comma
    skip_space
    check :on_comma
    write ","
    next_token

    first_space = current_token if space?
    skip_space

    if newline? || comment?
      consume_end_of_line
      write_indent
    elsif first_space && @preserve_whitespace
      write_space first_space[2]
      skip_space_or_newline
    else
      write_space
      skip_space_or_newline
    end
  end

  def visit_array(node)
    # [:array, elements]

    # Check if it's `%w(...)` or `%i(...)`
    case current_token_kind
    when :on_qwords_beg, :on_qsymbols_beg, :on_words_beg, :on_symbols_beg
      visit_q_or_i_array(node)
      return
    end

    _, elements = node

    check :on_lbracket
    write "["
    next_token

    if elements
      if elements[0].is_a?(Symbol)
        skip_space_or_newline
        visit elements
        skip_space_or_newline
      else
        visit_literal_elements elements
      end
    else
      skip_space_or_newline
    end

    check :on_rbracket
    write "]"
    next_token
  end

  def visit_q_or_i_array(node)
    _, elements = node

    # For %W it seems elements appear inside other arrays
    # for some reason, so we flatten them
    if elements[0].is_a?(Array) && elements[0][0].is_a?(Array)
      elements = elements.flat_map { |x| x }
    end

    write current_token_value.strip

    # If there's a newline after `%w(`, write line and indent
    if current_token_value.include?("\n") && elements
      write_line
      write_indent(next_indent)
    end

    next_token

    if elements
      elements.each_with_index do |elem, i|
        if elem[0] == :@tstring_content
          # elem is [:@tstring_content, string, [1, 5]
          write elem[1].strip
          next_token
        else
          visit elem
        end

        if !last?(i, elements) && current_token_kind == :on_words_sep
          # On a newline, write line and indent
          if current_token_value.include?("\n")
            next_token
            write_line
            write_indent(next_indent)
          else
            next_token
            write_space
          end
        end
      end
    end

    has_newline = false
    last_token = nil

    while current_token_kind == :on_words_sep
      has_newline ||= current_token_value.include?("\n")

      unless current_token[2].strip.empty?
        last_token = current_token
      end

      next_token
    end

    if has_newline
      write_line
      write_indent
    end

    if last_token
      write last_token[2].strip
    else
      write current_token_value.strip
      next_token
    end
  end

  def visit_hash(node)
    # [:hash, elements]
    _, elements = node

    check :on_lbrace
    write "{"
    next_token

    if elements
      # [:assoclist_from_args, elements]
      push_hash(node) do
        visit_literal_elements(elements[1], true)
      end
    else
      skip_space_or_newline
    end

    check :on_rbrace
    write "}"
    next_token
  end

  def visit_hash_key_value(node)
    # key => value
    #
    # [:assoc_new, key, value]
    _, key, value = node

    # If a symbol comes it means it's something like
    # `:foo => 1` or `:"foo" => 1` and a `=>`
    # always follows
    symbol = current_token_kind == :on_symbeg

    visit key

    consume_space(!@align_hash_keys)

    track_hash_key

    # Don't output `=>` for keys that are `label: value`
    # or `"label": value`
    if symbol || !(key[0] == :@label || key[0] == :dyna_symbol)
      consume_op "=>"
      consume_space(!@align_hash_keys)
    end

    visit value
  end

  def visit_splat_inside_hash(node)
    # **exp
    #
    # [:assoc_splat, exp]
    consume_op "**"
    skip_space_or_newline
    visit node[1]
  end

  def visit_range(node, inclusive)
    # [:dot2, left, right]
    _, left, right = node

    visit left
    skip_space_or_newline
    consume_op(inclusive ? ".." : "...")
    skip_space_or_newline
    visit right
  end

  def visit_regexp_literal(node)
    # [:regexp_literal, pieces, [:@regexp_end, "/", [1, 1]]]
    _, pieces = node

    check :on_regexp_beg
    write current_token_value
    next_token

    visit_exps pieces, false, false

    check :on_regexp_end
    write current_token_value
    next_token
  end

  def visit_array_access(node)
    # exp[arg1, ..., argN]
    #
    # [:aref, name, args]
    _, name, args = node

    visit_array_getter_or_setter name, args
  end

  def visit_array_setter(node)
    # exp[arg1, ..., argN]
    # (followed by `=`, though not included in this node)
    #
    # [:aref_field, name, args]
    _, name, args = node

    visit_array_getter_or_setter name, args
  end

  def visit_array_getter_or_setter(name, args)
    visit name

    check :on_lbracket
    write "["
    next_token

    column = @column

    skip_space

    # Sometimes args comes with an array...
    if args && args[0].is_a?(Array)
      visit_literal_elements args
    else
      if newline? || comment?
        needed_indent = next_indent
        if args
          consume_end_of_line
          write_indent(needed_indent)
        else
          skip_space_or_newline
        end
      else
        needed_indent = column
      end

      if args
        indent(needed_indent) do
          visit args
        end
      end
    end

    skip_space_or_newline

    check :on_rbracket
    write "]"
    next_token
  end

  def visit_sclass(node)
    # class << self
    #
    # [:sclass, target, body]
    _, target, body = node

    consume_keyword "class"
    consume_space
    consume_op "<<"
    consume_space
    visit target
    visit body
  end

  def visit_setter(node)
    # foo.bar
    # (followed by `=`, though not included in this node)
    #
    # [:field, receiver, :".", name]
    _, receiver, dot, name = node

    @dot_column = nil
    visit receiver
    skip_space

    if newline? || comment?
      consume_end_of_line

      write_indent(@dot_column || next_indent)
    end

    # Remember dot column
    dot_column = @column
    check :on_period
    write "."
    next_token
    skip_space

    if newline? || comment?
      consume_end_of_line
      write_indent(next_indent)
    else
      skip_space_or_newline
    end

    visit name

    # Only set it after we visit the call after the dot,
    # so we remember the outmost dot position
    @dot_column = dot_column
  end

  def visit_return(node)
    # [:return, exp]
    visit_control_keyword node, "return"
  end

  def visit_break(node)
    # [:break, exp]
    visit_control_keyword node, "break"
  end

  def visit_next(node)
    # [:next, exp]
    visit_control_keyword node, "next"
  end

  def visit_yield(node)
    # [:yield, exp]
    visit_control_keyword node, "yield"
  end

  def visit_control_keyword(node, keyword)
    _, exp = node

    consume_keyword keyword

    if exp && !exp.empty?
      consume_space if space?

      indent(@column) do
        # For `return a b` there comes many nodes, not just one... (see #8)
        if node[1][0].is_a?(Symbol)
          visit node[1]
        else
          visit_exps node[1], false, false
        end
      end
    end
  end

  def visit_lambda(node)
    # [:lambda, [:params, nil, nil, nil, nil, nil, nil, nil], [[:void_stmt]]]
    _, params, body = node

    check :on_tlambda
    write "->"
    next_token
    skip_space_or_newline

    if empty_params?(params)
      if current_token_kind == :on_lparen
        next_token
        skip_space_or_newline
        check :on_rparen
        next_token
        skip_space_or_newline
      end
    else
      visit params
      consume_space
    end

    if void_exps?(body)
      consume_token :on_tlambeg
      consume_space
      consume_token :on_rbrace
      return
    end

    brace = current_token_value == "{"

    if brace
      closing_brace_token, index = find_closing_brace_token

      # Check if the whole block fits into a single line
      if current_token[0][0] == closing_brace_token[0][0]
        consume_token :on_tlambeg

        consume_space
        visit_exps body, false, false
        consume_space

        consume_token :on_rbrace
        return
      end

      consume_token :on_tlambeg
    else
      consume_keyword "do"
    end

    indent_body body

    write_indent

    if brace
      consume_token :on_rbrace
    else
      consume_keyword "end"
    end
  end

  def visit_super(node)
    # [:super, args]
    _, args = node

    consume_keyword "super"

    if space?
      consume_space
      visit_command_end node, args
    else
      visit_call_at_paren node, args
    end
  end

  def visit_defined(node)
    # [:defined, exp]
    _, exp = node

    consume_keyword "defined?"
    skip_space_or_newline

    has_paren = current_token_kind == :on_lparen

    if has_paren
      write "("
      next_token
      skip_space_or_newline
    else
      consume_space
    end

    # exp can be [:paren, exp] if there's a parentheses,
    # though not always (only if there's a space after `defined?`)
    if exp[0] == :paren
      exp = exp[1]
    end

    visit exp

    if has_paren
      skip_space_or_newline
      check :on_rparen
      write ")"
      next_token
    end
  end

  def visit_alias(node)
    # [:alias, from, to]
    _, from, to = node

    consume_keyword "alias"
    consume_space
    visit from
    consume_space
    visit to
  end

  def visit_undef(node)
    # [:undef, exps]
    _, exps = node

    consume_keyword "undef"
    consume_space
    visit_comma_separated_list exps
  end

  def visit_literal_elements(elements, inside_hash = false)
    base_column = @column
    needs_final_space = inside_hash && space?
    skip_space

    case @space_after_hash_brace
    when :never
      needs_final_space = false
    when :always
      needs_final_space = true
    end

    if newline? || comment?
      needs_final_space = false
    elsif needs_final_space
      consume_space
      base_column = @column
    end

    # If there's a newline right at the beginning,
    # write it, and we'll indent element and always
    # add a trailing comma to the last element
    needs_trailing_comma = newline? || comment?
    if needs_trailing_comma
      needed_indent = next_indent
      indent { consume_end_of_line }
      write_indent(needed_indent)
    else
      needed_indent = base_column
    end

    elements.each_with_index do |elem, i|
      if needs_trailing_comma
        indent(needed_indent) { visit elem }
      else
        visit elem
      end
      skip_space

      next unless comma?
      is_last = last?(i, elements)

      write "," unless is_last
      next_token
      skip_space

      if newline? || comment?
        if is_last
          # Nothing
        else
          consume_end_of_line
          write_indent(needed_indent)
        end
      else
        write_space unless is_last
      end
    end

    if needs_trailing_comma
      write ","
      consume_end_of_line
      write_indent
    elsif comment?
      consume_end_of_line
    else
      if needs_final_space
        consume_space
      else
        skip_space_or_newline
      end
    end
  end

  def visit_if(node)
    visit_if_or_unless node, "if"
  end

  def visit_unless(node)
    visit_if_or_unless node, "unless"
  end

  def visit_if_or_unless(node, keyword, check_end = true)
    # if cond
    #   then_body
    # else
    #   else_body
    # end
    #
    # [:if, cond, then, else]
    consume_keyword(keyword)
    consume_space
    visit node[1]
    skip_space

    # Remove "then"
    if keyword?("then")
      next_token
      skip_space
    end

    indent_body node[2]
    if else_body = node[3]
      # [:else, else_contents]
      # [:elsif, cond, then, else]
      write_indent

      case else_body[0]
      when :else
        consume_keyword "else"
        indent_body else_body[1]
      when :elsif
        visit_if_or_unless else_body, "elsif", false
      else
        bug "expected else or elsif, not #{else_body[0]}"
      end
    end

    if check_end
      write_indent
      consume_keyword "end"
    end
  end

  def visit_while(node)
    # [:while, cond, body]
    visit_while_or_until node, "while"
  end

  def visit_until(node)
    # [:until, cond, body]
    visit_while_or_until node, "until"
  end

  def visit_while_or_until(node, keyword)
    _, cond, body = node

    consume_keyword keyword
    consume_space

    visit cond

    skip_space

    # Keep `while cond; end` as is
    semicolon = semicolon?
    is_do = keyword?("do")

    if (semicolon || is_do) && void_exps?(body)
      next_token
      skip_space

      if keyword?("end")
        if is_do
          write " do end"
        else
          write "; end"
        end
        next_token
        return
      end
    end

    if semicolon || is_do
      next_token
      skip_space
      skip_semicolons

      if newline? || comment?
        indent_body body
        write_indent
      else
        skip_space_or_newline
        if semicolon
          write "; "
        else
          write " do "
        end
        visit_exps body, false, false
        skip_space_or_newline
        write_space if is_do
      end
    else
      indent_body body
      write_indent
    end

    consume_keyword "end"
  end

  def visit_case(node)
    # [:case, cond, case_when]
    _, cond, case_when = node

    consume_keyword "case"

    if cond
      consume_space
      visit cond
    end

    consume_end_of_line

    write_indent
    visit case_when

    write_indent
    consume_keyword "end"
  end

  def visit_when(node)
    # [:when, conds, body, next_exp]
    _, conds, body, next_exp = node

    consume_keyword "when"
    consume_space

    indent(@column) do
      visit_comma_separated_list conds
      skip_space
    end

    then_keyword = keyword?("then")
    inline = then_keyword || semicolon?
    if then_keyword
      next_token
      skip_space
      track_case_when
      skip_semicolons

      if newline? || comment?
        inline = false

        # Cancel tracking of `case when ... then` on a nelwine.
        @case_when_positions.pop
      else
        write " then "
      end
    elsif semicolon?
      skip_semicolons

      if newline? || comment?
        inline = false
      else
        write ";"
        track_case_when
        write " "
      end
    end

    if inline
      indent do
        visit_exps body
      end
    else
      indent_body body
    end

    if next_exp
      write_indent

      if next_exp[0] == :else
        # [:else, body]
        consume_keyword "else"
        skip_space

        if newline? || semicolon? || comment?
          indent_body next_exp[1]
        else
          write_space
          visit_exps next_exp[1]
        end
      else
        visit next_exp
      end
    end
  end

  def consume_space(want_preserve_whitespace = false)
    first_space = current_token if space?
    skip_space
    if want_preserve_whitespace && @preserve_whitespace && !newline? && !comment? && first_space
      write_space first_space[2] unless @output[-1] == " "
      skip_space_or_newline
    else
      skip_space_or_newline
      write_space unless @output[-1] == " "
    end
  end

  def skip_space
    next_token while space?
  end

  def skip_space_backslash
    return [false, false] unless space?

    first_space = current_token
    has_slash_newline = false
    while space?
      has_slash_newline ||= current_token_value == "\\\n"
      next_token
    end
    [has_slash_newline, first_space]
  end

  def skip_space_or_newline(_want_semicolon = false, write_first_semicolon = false)
    found_newline = false
    found_comment = false
    found_semicolon = false
    last = nil

    loop do
      case current_token_kind
      when :on_sp
        next_token
      when :on_nl, :on_ignored_nl
        next_token
        last = :newline
        found_newline = true
      when :on_semicolon
        if (!found_newline && !found_comment) || (!found_semicolon && write_first_semicolon)
          write "; "
        end
        next_token
        last = :semicolon
        found_semicolon = true
      when :on_comment
        write_line if last == :newline

        write_indent if found_comment
        if current_token_value.end_with?("\n")
          write current_token_value.rstrip
          write_line
        else
          write current_token_value
        end
        next_token
        found_comment = true
        last = :comment
      else
        break
      end
    end

    found_semicolon
  end

  def skip_semicolons
    while semicolon? || space?
      next_token
    end
  end

  def empty_body?(body)
    body[0] == :bodystmt &&
      body[1].size == 1 &&
      body[1][0][0] == :void_stmt
  end

  def consume_token(kind)
    check kind
    consume_token_value(current_token_value)
    next_token
  end

  def consume_token_value(value)
    write value

    # If the value has newlines, we need to adjust line and column
    number_of_lines = value.count("\n")
    if number_of_lines > 0
      @line += number_of_lines
      last_line_index = value.rindex("\n")
      @column = value.size - (last_line_index + 1)
      @last_was_newline = @column == 0
    end
  end

  def consume_keyword(value)
    check :on_kw
    if current_token_value != value
      bug "Expected keyword #{value}, not #{current_token_value}"
    end
    write value
    next_token
  end

  def consume_op(value)
    check :on_op
    if current_token_value != value
      bug "Expected op #{value}, not #{current_token_value}"
    end
    write value
    next_token
  end

  # Consume and print an end of line, handling semicolons and comments
  #
  # - at_prefix: are we at a point before an expression? (if so, we don't need a space before the first comment)
  # - want_semicolon: do we want do print a semicolon to separate expressions?
  # - want_multiline: do we want multiple lines to appear, or at most one?
  def consume_end_of_line(at_prefix = false, want_semicolon = false, want_multiline = true, needs_two_lines_on_comment = false)
    found_newline = false            # Did we find any newline during this method?
    last = nil                       # Last token kind found
    multilple_lines = false          # Did we pass through more than one newline?
    last_comment_has_newline = false # Does the last comment has a newline?
    newline_count = 0                # Number of newlines we passed

    loop do
      case current_token_kind
      when :on_sp
        # Ignore spaces
        next_token
      when :on_nl, :on_ignored_nl
        # I don't know why but sometimes a on_ignored_nl
        # can appear with nil as the "text", and that's wrong
        if current_token[2].nil?
          next_token
          next
        end

        if last == :newline
          # If we pass through consecutive newlines, don't print them
          # yet, but remember this fact
          multilple_lines = true unless last_comment_has_newline
        else
          # If we just printed a comment that had a newline,
          # we must print two newlines because we remove newlines from comments (rstrip call)
          if last == :comment && last_comment_has_newline
            write_line
            multilple_lines = true
          else
            write_line
            multilple_lines = false
          end
        end
        found_newline = true
        next_token
        last = :newline
        newline_count += 1
      when :on_semicolon
        next_token
        # If we want to print semicolons and we didn't find a newline yet,
        # print it, but only if it's not followed by a newline
        if !found_newline && want_semicolon && last != :semicolon
          skip_space
          case current_token_kind
          when :on_ignored_nl, :on_eof
          else
            write "; "
            last = :semicolon
          end
        end
        multilple_lines = false
      when :on_comment
        if last == :comment
          # Since we remove newlines from comments, we must add the last
          # one if it was a comment
          write_line
          write_indent
        else
          if found_newline
            if newline_count == 1 && needs_two_lines_on_comment
              if multilple_lines
                write_line
                multilple_lines = false
              else
                multilple_lines = true
              end
              needs_two_lines_on_comment = false
            end

            # Write line or second line if needed
            write_line if last != :newline || multilple_lines
            write_indent
          else
            # If we didn't find any newline yet, this is the first comment,
            # so append a space if needed (for example after an expression)
            write_space unless at_prefix
            track_comment
          end
        end
        last_comment_has_newline = current_token_value.end_with?("\n")
        write current_token_value.rstrip
        next_token
        last = :comment
        multilple_lines = false
      when :on_embdoc_beg
        write_line if multilple_lines

        consume_embedded_comment
        last = :comment
        last_comment_has_newline = true
      else
        break
      end
    end

    # Output a newline if we didn't do so yet:
    # either we didn't find a newline and we are at the end of a line (and we didn't just pass a semicolon),
    # or the last thing was a comment (from which we removed the newline)
    # or we just passed multiple lines (but printed only one)
    if (!found_newline && !at_prefix && !(want_semicolon && last == :semicolon)) ||
      last == :comment ||
      (multilple_lines && want_multiline)
      write_line
    end
  end

  def consume_embedded_comment
    write current_token_value
    next_token

    while current_token_kind != :on_embdoc_end
      write current_token_value
      next_token
    end

    write current_token_value.rstrip
    next_token
  end

  def consume_end
    return unless current_token_kind == :on___end__

    line = current_token[0][0]

    write_line
    consume_token :on___end__

    lines = @code.lines[line..-1]
    lines.each do |line|
      write line.chomp
      write_line
    end
  end

  def indent(value = nil)
    if value
      old_indent = @indent
      @indent = value
      yield
      @indent = old_indent
    else
      @indent += @indent_size
      yield
      @indent -= @indent_size
    end
  end

  def indent_body(exps)
    indent do
      consume_end_of_line(false, false, false)
    end

    # A then keyword can appear after a newline after an `if`, `unless`, etc.
    # Since that's a super weird formatting for if, probably way too obsolete
    # by now, we just remove it.
    if keyword?("then")
      next_token
      skip_space_or_newline
    end

    # If the body is [[:void_stmt]] it's an empty body
    # so there's nothing to write
    if exps.size == 1 && exps[0][0] == :void_stmt
      skip_space_or_newline
    else
      indent do
        visit_exps exps, true
      end
      write_line unless @last_was_newline
    end
  end

  def maybe_indent(toggle, indent_size)
    if toggle
      indent(indent_size) do
        yield
      end
    else
      yield
    end
  end

  def write(value)
    @output << value
    @last_was_newline = false
    @column += value.size
  end

  def write_space(value = " ")
    @output << value
    @column += 1
  end

  def write_line
    @output << "\n"
    @last_was_newline = true
    @column = 0
    @line += 1
  end

  def write_indent(indent = @indent)
    @output << " " * indent
    @column += indent
    @last_was_newline = false
  end

  def indent_after_space(node, sticky = false, want_space = true, first_space = nil)
    first_space = current_token if space?

    skip_space
    case current_token_kind
    when :on_ignored_nl, :on_comment
      indent do
        consume_end_of_line
        write_indent
        visit node
      end
    else
      if want_space
        if first_space && @preserve_whitespace
          write_space first_space[2]
        else
          write_space
        end
      end
      if sticky
        indent(@column) do
          visit node
        end
      else
        visit node
      end
    end
  end

  def next_indent
    @indent + @indent_size
  end

  def check(kind)
    if current_token_kind != kind
      bug "Expected token #{kind}, not #{current_token_kind}"
    end
  end

  def bug(msg)
    raise Rufo::Bug.new("#{msg} at #{current_token}")
  end

  # [[1, 0], :on_int, "1"]
  def current_token
    @tokens.last
  end

  def current_token_kind
    tok = current_token
    tok ? tok[1] : :on_eof
  end

  def current_token_value
    tok = current_token
    tok ? tok[2] : ""
  end

  def keyword?(kw)
    current_token_kind == :on_kw && current_token_value == kw
  end

  def newline?
    current_token_kind == :on_nl || current_token_kind == :on_ignored_nl
  end

  def comment?
    current_token_kind == :on_comment
  end

  def semicolon?
    current_token_kind == :on_semicolon
  end

  def comma?
    current_token_kind == :on_comma
  end

  def space?
    current_token_kind == :on_sp
  end

  def void_exps?(node)
    node.size == 1 && node[0].size == 1 && node[0][0] == :void_stmt
  end

  def find_closing_brace_token
    count = 0
    i = @tokens.size - 1
    while i >= 0
      token = @tokens[i]
      (line, column), kind = token
      case kind
      when :on_lbrace, :on_tlambeg
        count += 1
      when :on_rbrace
        count -= 1
        return [token, i] if count == 0
      end
      i -= 1
    end
    nil
  end

  def newline_follows_token(index)
    index -= 1
    while index >= 0
      token = @tokens[index]
      case current_token_kind
      when :on_sp
        # OK
      when :on_nl, :on_ignored_nl
        return true
      else
        return false
      end
      index -= 1
    end
    true
  end

  def next_token
    @tokens.pop

    if newline? && !@heredocs.empty?
      flush_heredocs
    end
  end

  def last?(i, array)
    i == array.size - 1
  end

  def push_call(node)
    push_node(node) do
      # A call can specify hash arguments so it acts as a
      # hash for key alignment purposes
      push_hash(node) do
        yield
      end
    end
  end

  def push_node(node)
    old_node = @current_node
    @current_node = node

    yield

    @current_node = old_node
  end

  def push_hash(node)
    old_hash = @current_hash
    @current_hash = node
    yield
    @current_hash = old_hash
  end

  def do_align_comments
    do_align @comments_positions, :comment
  end

  def do_align_assignments
    do_align @assignments_positions, :assign
  end

  def do_align_hash_keys
    do_align @hash_keys_positions, :hash_key
  end

  def do_align_case_when
    do_align @case_when_positions, :case
  end

  def do_align(elements, scope)
    lines = @output.lines

    # Chunk comments that are in consecutive lines
    chunks = chunk_while(elements) do |(l1, c1, i1, id1), (l2, c2, i2, id2)|
      l1 + 1 == l2 && i1 == i2 && id1 == id2
    end

    chunks.each do |comments|
      next if comments.size == 1

      if scope == :hash_key
        # Don't indent successive hash keys if any of them is in turn a hash
        # or array literal that is formatted in separate lines.
        has_brace_newline = comments.any? do |(l, c)|
          line_end = lines[l][c..-1]
          line_end.start_with?("=> {\n", "=> [\n", "=> [ #", "=> { #", "[\n", "{\n", "[ #", "{ #")
        end
        next if has_brace_newline
      end

      max_column = comments.map { |l, c| c }.max

      comments.each do |(line, column, _, _, offset)|
        next if column == max_column

        split_index = column
        split_index -= offset if offset

        target_line = lines[line]

        before = target_line[0...split_index]
        after = target_line[split_index..-1]

        filler_size = max_column - column
        filler = " " * filler_size

        # Move all lines affected by the assignment shift
        if scope == :assign && (range = @assignments_ranges[line])
          (line + 1..range).each do |line_number|
            lines[line_number] = "#{filler}#{lines[line_number]}"

            # And move other elements too if applicable
            adjust_other_alignments scope, line_number, column, filler_size
          end
        end

        # Move comments to the right if a change happened
        if scope != :comment
          adjust_other_alignments scope, line, column, filler_size
        end

        lines[line] = "#{before}#{filler}#{after}"
      end
    end

    @output = lines.join
  end

  def adjust_other_alignments(scope, line, column, offset)
    adjustments = @line_to_alignments_positions[line]
    return unless adjustments

    adjustments.each do |key, adjustment_column, target, index|
      next if adjustment_column <= column
      next if scope == key

      target[index][1] += offset
    end
  end

  def chunk_while(array, &block)
    if array.respond_to?(:chunk_while)
      array.chunk_while(&block)
    else
      Rufo::Backport.chunk_while(array, &block)
    end
  end

  def result
    @output
  end
end
