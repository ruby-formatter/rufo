# frozen_string_literal: true

class Rufo::Formatter
  include Rufo::Settings

  INDENT_SIZE = 2
  EMPTY_STRING = [:string_literal, [:string_content]]
  EMPTY_HASH = [:hash, nil]

  def self.format(code, **options)
    formatter = new(code, **options)
    formatter.format
    formatter.result
  end

  def initialize(code, **options)
    @code = code

    @tokens = Rufo::Parser.lex(code).reverse!
    @sexp = Rufo::Parser.sexp(code)

    # sexp being nil means that the code is not valid.
    # Parse the code so we get better error messages.
    if @sexp.nil?
      Rufo::Parser.parse(code)
      raise Rufo::UnknownSyntaxError # Sometimes parsing does not raise an error
    end

    @indent = 0
    @line = 0
    @column = 0
    @last_was_newline = true
    @output = +""

    # The column of a `obj.method` call, so we can align
    # calls to that dot
    @dot_column = nil

    # Same as above, but the column of the original dot, not
    # the one we finally wrote
    @original_dot_column = nil

    # Did this line already set the `@dot_column` variable?
    @line_has_dot_column = nil

    # The column of a `obj.method` call, but only the name part,
    # so we can also align arguments accordingly
    @name_dot_column = nil

    # Heredocs list, associated with calls ([heredoc, tilde])
    @heredocs = []

    # Current node, to be able to associate it to heredocs
    @current_node = nil

    # The current heredoc being printed
    @current_heredoc = nil

    # The current hash or call or method that has hash-like parameters
    @current_hash = nil

    @current_type = nil

    # Are we inside a type body?
    @inside_type_body = false

    # Map lines to commands that start at the begining of a line with the following info:
    # - line indent
    # - first param indent
    # - first line ends with '(', '[' or '{'?
    # - line of matching pair of the previous item
    # - last line of that call
    #
    # This is needed to dedent some calls that look like this:
    #
    # foo bar(
    #   2,
    # )
    #
    # Without the dedent it would normally look like this:
    #
    # foo bar(
    #       2,
    #     )
    #
    # Because the formatter aligns this to the first parameter in the call.
    # However, for these cases it's better to not align it like that.
    @line_to_call_info = {}

    # Lists [first_line, last_line, indent] of lines that need an indent because
    # of alignment of literals. For example this:#
    #
    #     foo [
    #           1,
    #         ]
    #
    # is normally formatted to:
    #
    #     foo [
    #       1,
    #     ]
    #
    # However, if it's already formatted like the above we preserve it.
    @literal_indents = []

    # First non-space token in this line
    @first_token_in_line = nil

    # Do we want to compute the above?
    @want_first_token_in_line = false

    # Each line that belongs to a string literal besides the first
    # go here, so we don't break them when indenting/dedenting stuff
    @unmodifiable_string_lines = {}

    # Position of comments that occur at the end of a line
    @comments_positions = []

    # Token for the last comment found
    @last_comment = nil

    # Actual column of the last comment written
    @last_comment_column = nil

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

    # Case when positions
    @case_when_positions = []

    # Declarations that are written in a single line, like:
    #
    #    def foo; 1; end
    #
    # We want to track these because we allow consecutive inline defs
    # to be together (without an empty line between them)
    #
    # This is [[line, original_line], ...]
    @inline_declarations = []

    # This is used to track how far deep we are in the AST.
    # This is useful as it allows you to check if you are inside an array
    # when dealing with heredocs.
    @node_level = 0

    # This represents the node level of the most recent literal elements list.
    # It is used to track if we are in a list of elements so that commas
    # can be added appropriately for heredocs for example.
    @literal_elements_level = nil

    init_settings(options)
  end

  def format
    visit @sexp
    consume_end
    write_line if !@last_was_newline || @output == ""
    @output.chomp! if @output.end_with?("\n\n")

    dedent_calls
    indent_literals
    do_align_case_when if align_case_when
    remove_lines_before_inline_declarations
    @output.lstrip!
    @output = "\n" if @output.empty?
  end

  def visit(node)
    @node_level += 1
    unless node.is_a?(Array)
      bug "unexpected node: #{node} at #{current_token}"
    end

    case node.first
    when :program
      # Topmost node
      #
      # [:program, exps]
      visit_exps node[1], with_indent: true
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
      # [:@float, "123.45", [1, 0]]
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
      looking_at_newline = current_token_kind == :on_tstring_content && current_token_value == "\n"
      if heredoc && tilde && !@last_was_newline && looking_at_newline
        check :on_tstring_content
        consume_token_value(current_token_value)
        next_token
      else
        # For heredocs with tilde we sometimes need to align the contents
        if heredoc && tilde && @last_was_newline
          unless (current_token_value == "\n" ||
                  current_token_kind == :on_heredoc_end)
            write_indent(next_indent)
          end
          skip_ignored_space
          if current_token_kind == :on_tstring_content
            check :on_tstring_content
            consume_token_value(current_token_value)
            next_token
          end
        else
          while (current_token_kind == :on_ignored_sp) ||
                (current_token_kind == :on_tstring_content) ||
                (current_token_kind == :on_embexpr_beg)
            check current_token_kind
            break if current_token_kind == :on_embexpr_beg
            consume_token current_token_kind
          end
        end
      end
    when :string_content
      # [:string_content, exp]
      visit_exps node[1..-1], with_lines: false
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
    when :mlhs
      visit_mlhs(node)
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
    when :rest_param
      visit_rest_param(node)
    when :kwrest_param
      visit_kwrest_param(node)
    when :retry
      # [:retry]
      consume_keyword "retry"
    when :redo
      # [:redo]
      consume_keyword "redo"
    when :for
      visit_for(node)
    when :BEGIN
      visit_begin_node(node)
    when :END
      visit_end_node(node)
    when :args_forward
      consume_op("...")
    else
      bug "Unhandled node: #{node.first}"
    end
  ensure
    @node_level -= 1
  end

  def visit_exps(exps, with_indent: false, with_lines: true, want_trailing_multiline: false)
    consume_end_of_line(at_prefix: true)

    line_before_endline = nil

    exps.each_with_index do |exp, i|
      next if exp == :string_content

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

      line_before_exp = @line
      original_line = current_token_line

      push_node(exp) do
        visit exp
      end

      if declaration?(exp) && @line == line_before_exp
        @inline_declarations << [@line, original_line]
      end

      is_last = last?(i, exps)

      line_before_endline = @line

      if with_lines
        exp_needs_two_lines = needs_two_lines?(exp)

        consume_end_of_line(want_semicolon: !is_last, want_multiline: !is_last || want_trailing_multiline, needs_two_lines_on_comment: exp_needs_two_lines)

        # Make sure to put two lines before defs, class and others
        if !is_last && (exp_needs_two_lines || needs_two_lines?(exps[i + 1])) && @line <= line_before_endline + 1
          write_line
        end
      elsif !is_last
        skip_space

        has_semicolon = semicolon?
        skip_semicolons
        if newline?
          write_line
          write_indent(next_indent)
        elsif has_semicolon
          write "; "
        end
        skip_space_or_newline
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

  def declaration?(exp)
    case exp[0]
    when :def, :class, :module
      true
    else
      false
    end
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
      # Get the next_token while capturing any output.
      # This is needed so that we can add a comma if one is not already present.
      captured_output = capture_output { next_token }

      inside_literal_elements_list = !@literal_elements_level.nil? &&
                                     (@node_level - @literal_elements_level) == 2
      needs_comma = !comma? && trailing_commas

      if inside_literal_elements_list && needs_comma
        write ","
        @last_was_heredoc = true
      end

      @output << captured_output
      return
    elsif current_token_kind == :on_backtick
      consume_token :on_backtick
    else
      return if format_simple_string(node)
      consume_token :on_tstring_beg
    end

    visit_string_literal_end(node)
  end

  # For simple string formatting, look for nodes like:
  #  [:string_literal, [:string_content, [:@tstring_content, "abc", [...]]]]
  # and return the simple string inside.
  def simple_string(node)
    inner = node[1][1..-1]
    return if inner.length > 1
    inner = inner[0]
    return "" if !inner
    return if inner[0] != :@tstring_content
    string = inner[1]
    string
  end

  # Which quote character are we using?
  def quote_char
    (quote_style == :double) ? '"' : "'"
  end

  # should we format this string according to :quote_style?
  def should_format_string?(string)
    # don't format %q or %Q
    return unless current_token_value == "'" || current_token_value == '"'
    # don't format strings containing slashes
    return if string.include?("\\")
    # don't format strings that contain our quote character
    return if string.include?(quote_char)
    return if string.include?('#{')
    return if string.include?('#$')
    true
  end

  def format_simple_string(node)
    # is it a simple string node?
    string = simple_string(node)
    return if !string

    # is it eligible for formatting?
    return if !should_format_string?(string)

    # success!
    write quote_char
    next_token
    with_unmodifiable_string_lines do
      inner = node[1][1..-1]
      visit_exps(inner, with_lines: false)
    end
    write quote_char
    next_token

    true
  end

  # Every line between the first line and end line of this string (excluding the
  # first line) must remain like it is now (we don't want to mess with that when
  # indenting/dedenting)
  #
  # This can happen with heredocs, but also with string literals spanning
  # multiple lines.
  def with_unmodifiable_string_lines
    line = @line
    yield
    (line + 1..@line).each do |i|
      @unmodifiable_string_lines[i] = true
    end
  end

  def visit_string_literal_end(node)
    inner = node[1]
    inner = inner[1..-1] unless node[0] == :xstring_literal

    with_unmodifiable_string_lines do
      visit_exps(inner, with_lines: false)
    end

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

    token_column = current_token_column
    base_column = @column

    visit string1

    has_backslash, _ = skip_space_backslash
    if has_backslash
      write " \\"
      write_line

      # If the strings are aligned, like in:
      #
      # foo bar, "hello" \
      #          "world"
      #
      # then keep it aligned.
      if token_column == current_token_column
        write_indent(base_column)
      else
        write_indent
      end
    else
      consume_space
    end

    visit string2
  end

  def visit_string_interpolation(node)
    # [:string_embexpr, exps]
    consume_token :on_embexpr_beg
    skip_space_or_newline
    if current_token_kind == :on_tstring_content
      next_token
    end
    visit_exps(node[1], with_lines: false)
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
    visit_exps node[1..-1], with_lines: false
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
      visit_exps exps, with_lines: false
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
    consume_space

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
    consume_space

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

    first_space = skip_space

    # A trailing comma can come after the left hand side
    if comma?
      consume_token :on_comma
      first_space = skip_space
    end

    write_space_using_setting(first_space, :one)

    track_assignment
    consume_op "="
    visit_assign_value right
  end

  def visit_assign_value(value)
    has_slash_newline, _first_space = skip_space_backslash

    # Remove backslash after equal + newline (it's useless)
    if has_slash_newline
      skip_space_or_newline
      write_space
      indent(next_indent) do
        visit(value)
      end
    else
      if [:begin, :case, :if, :unless].include?(value.first)
        skip_space_or_newline
        write_space
        indent(next_indent) do
          visit value
        end
      else
        indent_after_space value, sticky: false,
                                  want_space: true
      end
    end
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

      _, _, rescue_body, else_body, ensure_body = body
      rescue_body || else_body || ensure_body
    else
      false
    end
  end

  def current_comment_aligned_to_previous_one?
    @last_comment &&
      @last_comment[0][0] + 1 == current_token_line &&
      @last_comment[0][1] == current_token_column
  end

  def track_comment(id: nil, match_previous_id: false)
    if match_previous_id && !@comments_positions.empty?
      id = @comments_positions.last[3]
    end

    @line_to_alignments_positions[@line] << [:comment, @column, @comments_positions, @comments_positions.size]
    @comments_positions << [@line, @column, 0, id, 0]
  end

  def track_assignment(offset = 0)
    track_alignment :assign, @assignments_positions, offset
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
    info = [@line, @column, @indent, id, offset]
    target << info
    info
  end

  def visit_ternary_if(node)
    # cond ? then : else
    #
    # [:ifop, cond, then_body, else_body]
    _, cond, then_body, else_body = node

    visit cond
    consume_space
    consume_op "?"
    consume_space_or_newline
    visit then_body
    consume_space
    consume_op ":"
    consume_space_or_newline
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
    consume_space
    consume_keyword(suffix)
    consume_space_or_newline
    visit cond
  end

  def visit_call_with_receiver(node)
    # [:call, obj, :".", name]
    _, obj, _, name = node

    @dot_column = nil
    visit obj

    first_space = skip_space

    if newline? || comment?
      consume_end_of_line

      # If align_chained_calls is off, we still want to preserve alignment if it's already there
      if align_chained_calls || (@original_dot_column && @original_dot_column == current_token_column)
        @name_dot_column = @dot_column || next_indent
        write_indent(@dot_column || next_indent)
      else
        # Make sure to reset dot_column so next lines don't align to the first dot
        @dot_column = next_indent
        @name_dot_column = next_indent
        write_indent(next_indent)
      end
    else
      write_space_using_setting(first_space, :no)
    end

    # Remember dot column, but only if there isn't one already set
    unless @dot_column
      dot_column = @column
      original_dot_column = current_token_column
    end

    consume_call_dot

    skip_space_or_newline_using_setting(:no, next_indent)

    if name == :call
      # :call means it's .()
    else
      visit name
    end

    # Only set it after we visit the call after the dot,
    # so we remember the outmost dot position
    @dot_column = dot_column if dot_column
    @original_dot_column = original_dot_column if original_dot_column
  end

  def consume_call_dot
    if current_token_kind == :on_op
      consume_token :on_op
    else
      consume_token :on_period
    end
  end

  def visit_call_without_receiver(node)
    # foo(arg1, ..., argN)
    #
    # [:method_add_arg,
    #   [:fcall, [:@ident, "foo", [1, 0]]],
    #   [:arg_paren, [:args_add_block, [[:@int, "1", [1, 6]]], false]]]
    _, name, args = node

    @name_dot_column = nil
    visit name

    # Some times a call comes without parens (should probably come as command, but well...)
    return if args.empty?

    # Remember dot column so it's not affected by args
    dot_column = @dot_column
    original_dot_column = @original_dot_column

    want_indent = @name_dot_column && @name_dot_column > @indent

    maybe_indent(want_indent, @name_dot_column) do
      visit_call_at_paren(node, args)
    end

    # Restore dot column so it's not affected by args
    @dot_column = dot_column
    @original_dot_column = original_dot_column
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
      if needs_trailing_newline && (call_info = @line_to_call_info[@line])
        call_info << true
      end

      want_trailing_comma = true

      # Check if there's a block arg and if the call ends with hash key/values
      if args_node[0] == :args_add_block
        _, args, block_arg = args_node
        want_trailing_comma = !block_arg
        if args.is_a?(Array) && (last_arg = args.last) && last_arg.is_a?(Array) &&
           last_arg[0].is_a?(Symbol) && last_arg[0] != :bare_assoc_hash
          want_trailing_comma = false
        end
      end

      push_call(node) do
        visit args_node
        skip_space
      end

      found_comma = comma?

      heredoc_needs_newline = true

      if found_comma
        if needs_trailing_newline
          write "," if trailing_commas && !block_arg

          next_token
          heredoc_needs_newline = !newline?
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
        if needs_trailing_newline && !@last_was_heredoc
          write "," if trailing_commas && want_trailing_comma

          indent(next_indent) do
            consume_end_of_line
          end
          write_indent
        else
          skip_space_or_newline
        end
      else
        if needs_trailing_newline && !found_comma
          write "," if trailing_commas && want_trailing_comma && !@last_was_heredoc
          consume_end_of_line
          write_indent
        end
      end
    else
      skip_space_or_newline
    end

    # If the closing parentheses matches the indent of the first parameter,
    # keep it like that. Otherwise dedent.
    if call_info && call_info[1] != current_token_column
      call_info << @line
    end

    if @last_was_heredoc && heredoc_needs_newline
      write_line
      write_indent
    end
    consume_token :on_rparen
  end

  def visit_command(node)
    # foo arg1, ..., argN
    #
    # [:command, name, args]
    _, name, args = node

    base_column = current_token_column

    push_call(node) do
      visit name
      consume_space_after_command_name
    end

    visit_command_end(node, args, base_column)
  end

  def visit_command_end(node, args, base_column)
    push_call(node) do
      visit_command_args(args, base_column)
    end
  end

  def flush_heredocs
    if comment?
      write_space unless @output[-1] == " "
      write current_token_value.rstrip
      next_token
      write_line
    end

    printed = false

    until @heredocs.empty?
      heredoc, tilde = @heredocs.first

      @heredocs.shift
      @current_heredoc = [heredoc, tilde]
      visit_string_literal_end(heredoc)
      @current_heredoc = nil
      printed = true
    end

    @last_was_heredoc = true if printed
  end

  def visit_command_call(node)
    # [:command_call,
    #   receiver
    #   :".",
    #   name
    #   [:args_add_block, [[:@int, "1", [1, 8]]], block]]
    _, receiver, _, name, args = node

    base_column = current_token_column

    visit receiver

    skip_space_or_newline

    # Remember dot column
    dot_column = @column
    original_dot_column = @original_dot_column

    consume_call_dot

    skip_space

    if newline? || comment?
      consume_end_of_line
      write_indent(next_indent)
    else
      skip_space_or_newline
    end

    visit name
    consume_space_after_command_name
    visit_command_args(args, base_column)

    # Only set it after we visit the call after the dot,
    # so we remember the outmost dot position
    @dot_column = dot_column
    @original_dot_column = original_dot_column
  end

  def consume_space_after_command_name
    has_backslash, first_space = skip_space_backslash
    if has_backslash
      write " \\"
      write_line
      write_indent(next_indent)
    else
      write_space_using_setting(first_space, :one)
    end
  end

  def visit_command_args(args, base_column)
    needed_indent = @column
    args_is_def_class_or_module = false
    param_column = current_token_column

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
            args_is_def_class_or_module = true
          end
        end
      end
    end

    base_line = @line
    call_info = @line_to_call_info[@line]
    if call_info
      call_info = nil
    else
      call_info = [@indent, @column]
      @line_to_call_info[@line] = call_info
    end

    old_want_first_token_in_line = @want_first_token_in_line
    @want_first_token_in_line = true

    # We align call parameters to the first paramter
    indent(needed_indent) do
      visit_exps to_ary(args), with_lines: false
    end

    if call_info && call_info.size > 2
      # A call like:
      #
      #     foo, 1, [
      #       2,
      #     ]
      #
      # would normally be aligned like this (with the first parameter):
      #
      #     foo, 1, [
      #            2,
      #          ]
      #
      # However, the first style is valid too and we preserve it if it's
      # already formatted like that.
      call_info << @line
    elsif !args_is_def_class_or_module && @first_token_in_line && param_column == @first_token_in_line[0][1]
      # If the last line of the call is aligned with the first parameter, leave it like that:
      #
      #     foo 1,
      #         2
    elsif !args_is_def_class_or_module && @first_token_in_line && base_column + INDENT_SIZE == @first_token_in_line[0][1]
      # Otherwise, align it just by two spaces (so we need to dedent, we fake a dedent here)
      #
      #     foo 1,
      #       2
      @line_to_call_info[base_line] = [0, needed_indent - next_indent, true, @line, @line]
    end

    @want_first_token_in_line = old_want_first_token_in_line
  end

  def visit_call_with_block(node)
    # [:method_add_block, call, block]
    _, call, block = node

    visit call

    consume_space

    old_dot_column = @dot_column
    old_original_dot_column = @original_dot_column

    visit block

    @dot_column = old_dot_column
    @original_dot_column = old_original_dot_column
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

    closing_brace_token, _ = find_closing_brace_token

    # If the whole block fits into a single line, use braces
    if current_token_line == closing_brace_token[0][0]
      consume_token :on_lbrace
      consume_block_args args
      consume_space
      visit_exps body, with_lines: false

      while semicolon?
        next_token
      end

      consume_space

      consume_token :on_rbrace
      return
    end

    # Otherwise it's multiline
    consume_token :on_lbrace
    consume_block_args args

    if (call_info = @line_to_call_info[@line])
      call_info << true
    end

    indent_body body, force_multiline: true
    write_indent

    # If the closing bracket matches the indent of the first parameter,
    # keep it like that. Otherwise dedent.
    if call_info && call_info[1] != current_token_column
      call_info << @line
    end

    consume_token :on_rbrace
  end

  def visit_do_block(node)
    # [:brace_block, args, body]
    _, args, body = node

    line = @line

    consume_keyword "do"

    consume_block_args args

    if body.first == :bodystmt
      visit_bodystmt body
    else
      indent_body body
      write_indent unless @line == line
      consume_keyword "end"
    end
  end

  def consume_block_args(args)
    if args
      consume_space_or_newline
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
    found_semicolon = skip_space_or_newline(_want_semicolon: true, write_first_semicolon: true)

    if found_semicolon
      # Nothing
    elsif empty_params && local_params
      consume_token :on_semicolon
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

      if comma?
        indent(next_indent) do
          write_params_comma
        end
      end

      consume_op "&"
      skip_space_or_newline
      visit block_arg
    end
  end

  def visit_args_add_star(node)
    # [:args_add_star, args, star, post_args]
    _, args, star, *post_args = node

    if newline? || comment?
      needs_indent = true
      base_column = next_indent
    else
      base_column = @column
    end
    if !args.empty? && args[0] == :args_add_star
      # arg1, ..., *star
      visit args
    elsif !args.empty?
      visit_comma_separated_list args
    else
      consume_end_of_line if needs_indent
    end

    skip_space

    write_params_comma if comma?
    write_indent(base_column) if needs_indent
    consume_op "*"
    skip_space_or_newline
    visit star

    if post_args && !post_args.empty?
      write_params_comma
      visit_comma_separated_list post_args, needs_indent: needs_indent, base_column: base_column
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
    # [:bodystmt, [[:@int, "1", [2, 1]]], nil, [[:@int, "2", [4, 1]]], nil] (2.6.0)
    _, body, rescue_body, else_body, ensure_body = node

    @inside_type_body = false

    line = @line

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
      # [[:@int, "2", [4, 1]]] (2.6.0)
      write_indent
      consume_keyword "else"
      else_body = else_body[1] if else_body[0] == :else
      indent_body else_body
    end

    if ensure_body
      # [:ensure, body]
      write_indent
      consume_keyword "ensure"
      indent_body ensure_body[1]
    end

    write_indent if @line != line
    consume_keyword "end"
  end

  def visit_rescue_types(node)
    visit_exps to_ary(node), with_lines: false
  end

  def visit_mrhs_new_from_args(node)
    # Multiple exception types
    # [:mrhs_new_from_args, exps, final_exp]
    _, exps, final_exp = node

    if final_exp
      visit_comma_separated_list exps
      write_params_comma
      visit final_exp
    else
      visit_comma_separated_list to_ary(exps)
    end
  end

  def visit_mlhs_paren(node)
    # [:mlhs_paren,
    #   [[:mlhs_paren, [:@ident, "x", [1, 12]]]]
    # ]
    _, args = node

    visit_mlhs_or_mlhs_paren(args)
  end

  def visit_mlhs(node)
    # [:mlsh, *args]
    _, *args = node

    visit_mlhs_or_mlhs_paren(args)
  end

  def visit_mlhs_or_mlhs_paren(args)
    # Sometimes a paren comes, some times not, so act accordingly.
    has_paren = current_token_kind == :on_lparen
    if has_paren
      consume_token :on_lparen
      skip_space_or_newline
    end

    # For some reason there's nested :mlhs_paren for
    # a single parentheses. It seems when there's
    # a nested array we need parens, otherwise we
    # just output whatever's inside `args`.
    if args.is_a?(Array) && args[0].is_a?(Array)
      indent(@column) do
        visit_comma_separated_list args
        skip_space_or_newline
      end
    else
      visit args
    end

    if has_paren
      # Ripper has a bug where parsing `|(w, *x, y), z|`,
      # the "y" isn't returned. In this case we just consume
      # all tokens until we find a `)`.
      while current_token_kind != :on_rparen
        consume_token current_token_kind
      end

      consume_token :on_rparen
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

    line = @line

    consume_keyword "for"
    consume_space

    visit_comma_separated_list to_ary(var)
    skip_space
    if comma?
      check :on_comma
      write ","
      next_token
      skip_space_or_newline
    end

    consume_space
    consume_keyword "in"
    consume_space
    visit collection
    skip_space

    indent_body body

    write_indent if @line != line
    consume_keyword "end"
  end

  def visit_begin_node(node)
    visit_begin_or_end node, "BEGIN"
  end

  def visit_end_node(node)
    visit_begin_or_end node, "END"
  end

  def visit_begin_or_end(node, keyword)
    # [:BEGIN, body]
    _, body = node

    consume_keyword(keyword)
    consume_space

    closing_brace_token, _index = find_closing_brace_token

    # If the whole block fits into a single line, format
    # in a single line
    if current_token_line == closing_brace_token[0][0]
      consume_token :on_lbrace
      consume_space
      visit_exps body, with_lines: false
      consume_space
      consume_token :on_rbrace
    else
      consume_token :on_lbrace
      indent_body body
      write_indent
      consume_token :on_rbrace
    end
  end

  def visit_comma_separated_list(nodes, needs_indent: false, base_column: nil)
    if newline? || comment?
      indent { consume_end_of_line }
      needs_indent = true
      base_column = next_indent
      write_indent(base_column)
    elsif needs_indent
      write_indent(base_column)
    else
      base_column ||= @column
    end

    nodes = to_ary(nodes)
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
      skip_space_or_newline_using_setting(:one, base_column)
    end
  end

  def visit_mlhs_add_star(node)
    # [:mlhs_add_star, before, star, after]
    _, before, star, after = node

    if before && !before.empty?
      # Maybe a Ripper bug, but if there's something before a star
      # then a star shouldn't be here... but if it is... handle it
      # somehow...
      if current_token_kind == :on_op && current_token_value == "*"
        star = before
      else
        visit_comma_separated_list to_ary(before)
        write_params_comma
      end
    end

    consume_op "*"

    if star
      skip_space_or_newline
      visit star
    end

    if after && !after.empty?
      write_params_comma
      visit_comma_separated_list after
    end
  end

  def visit_rest_param(node)
    # [:rest_param, name]

    _, name = node

    consume_op "*"

    if name
      skip_space_or_newline
      visit name
    end
  end

  def visit_kwrest_param(node)
    # [:kwrest_param, name]

    _, name = node

    if name
      skip_space_or_newline
      visit name
    end
  end

  def visit_unary(node)
    # [:unary, :-@, [:vcall, [:@ident, "x", [1, 2]]]]
    _, op, exp = node

    consume_op_or_keyword

    first_space = space?
    skip_space_or_newline

    if op == :not
      has_paren = current_token_kind == :on_lparen

      if has_paren && !first_space
        write "("
        next_token
        skip_space_or_newline
      elsif !has_paren && !consume_space
        write_space
      end

      visit exp

      if has_paren && !first_space
        skip_space_or_newline
        check :on_rparen
        write ")"
        next_token
      end
    else
      visit exp
    end
  end

  def visit_binary(node)
    # [:binary, left, op, right]
    _, left, _, right = node

    # If this binary is not at the beginning of a line, if there's
    # a newline following the op we want to align it with the left
    # value. So for example:
    #
    # var = left_exp ||
    #       right_exp
    #
    # But:
    #
    # def foo
    #   left_exp ||
    #     right_exp
    # end
    needed_indent = @column == @indent ? next_indent : @column
    base_column = @column
    token_column = current_token_column

    visit left
    needs_space = space?

    has_backslash, _ = skip_space_backslash
    if has_backslash
      needs_space = true
      write " \\"
      write_line
      write_indent(next_indent)
    else
      write_space
    end

    consume_op_or_keyword

    skip_space

    if newline? || comment?
      indent_after_space right,
                         want_space: needs_space,
                         needed_indent: needed_indent,
                         token_column: token_column,
                         base_column: base_column
    else
      write_space
      visit right
    end
  end

  def consume_op_or_keyword
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

    push_type(node) do
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

      @inside_type_body = true
      visit body
    end
  end

  def visit_module(node)
    # [:module,
    #   name
    #   [:bodystmt, body, nil, nil, nil]]
    _, name, body = node

    push_type(node) do
      consume_keyword "module"
      skip_space_or_newline
      write_space
      visit name

      @inside_type_body = true
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
    _, receiver, _, name, params, body = node

    consume_keyword "def"
    consume_space
    visit receiver
    skip_space_or_newline

    consume_call_dot

    skip_space_or_newline

    push_hash(node) do
      visit_def_from_name name, params, body
    end
  end

  def visit_def_from_name(name, params, body)
    visit name

    params = params[1] if params[0] == :paren

    skip_space

    if current_token_kind == :on_lparen
      next_token
      skip_space
      skip_semicolons
      broken_across_line = false

      if empty_params?(params)
        skip_space_or_newline
        check :on_rparen
        next_token
        write "()"
      else
        write "("

        if newline? || comment?
          broken_across_line = true
          indent(next_indent) do
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
        consume_keyword("nil") if current_token[1] == :on_kw
        check :on_rparen
        if broken_across_line
          write_line
          write_indent
        end
        write ")"
        next_token
      end
    elsif !empty_params?(params)
      if parens_in_def == :yes
        write "("
      else
        write_space
      end

      visit params
      write ")" if parens_in_def == :yes
      skip_space
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
    _, exps = node

    consume_token :on_lparen
    skip_space_or_newline

    heredoc = current_token_kind == :on_heredoc_beg
    if exps
      visit_exps to_ary(exps), with_lines: false
    end

    skip_space_or_newline
    write "\n" if heredoc
    consume_token :on_rparen
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
        consume_space
        consume_op "="
        consume_space
        visit default
      end
      needs_comma = true
    end

    if rest_param
      # check for trailing , |x, | (may be [:excessed_comma] in 2.6.0)
      case rest_param
      when 0, [:excessed_comma]
        write_params_comma
      when [:args_forward]
        consume_op "..."
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
    skip_space_or_newline_using_setting(:one)
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

    token_column = current_token_column

    check :on_lbracket
    write "["
    next_token

    if elements
      visit_literal_elements to_ary(elements), inside_array: true, token_column: token_column
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

    has_space = current_token_value.end_with?(" ")
    write current_token_value.strip

    # (pre 2.5.0) If there's a newline after `%w(`, write line and indent
    if current_token_value.include?("\n") && elements # "%w[\n"
      write_line
      write_indent next_indent
    end

    next_token

    # fix for 2.5.0 ripper change
    if current_token_kind == :on_words_sep && elements && !elements.empty?
      value = current_token_value
      has_space = value.start_with?(" ")
      if value.include?("\n") && elements # "\n "
        write_line
        write_indent next_indent
      end
      next_token
      has_space = true if current_token_value.start_with?(" ")
    end

    if elements && !elements.empty?
      write_space if has_space
      column = @column

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
            write_indent(column)
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
    elsif has_space && elements && !elements.empty?
      write_space
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
    token_column = current_token_column

    closing_brace_token, _ = find_closing_brace_token
    need_space = need_space_for_hash?(node, closing_brace_token)

    check :on_lbrace
    write "{"
    brace_position = @output.length - 1
    write " " if need_space
    next_token

    if elements
      # [:assoclist_from_args, elements]
      push_hash(node) do
        visit_literal_elements(elements[1], inside_hash: true, token_column: token_column)
      end
      char_after_brace = @output[brace_position + 1]
      # Check that need_space is set correctly.
      if !need_space && !["\n", " "].include?(char_after_brace)
        need_space = true
        # Add a space in the missing position.
        @output.insert(brace_position + 1, " ")
      end
    else
      skip_space_or_newline
    end

    check :on_rbrace
    write " " if need_space
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
    arrow = symbol || !(key[0] == :@label || key[0] == :dyna_symbol)

    visit key
    consume_space

    # Don't output `=>` for keys that are `label: value`
    # or `"label": value`
    if arrow
      consume_op "=>"
      consume_space
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

    visit left unless left.nil?
    skip_space_or_newline
    consume_op(inclusive ? ".." : "...")
    skip_space_or_newline
    visit right unless right.nil?
  end

  def visit_regexp_literal(node)
    # [:regexp_literal, pieces, [:@regexp_end, "/", [1, 1]]]
    _, pieces = node

    check :on_regexp_beg
    write current_token_value
    next_token

    visit_exps pieces, with_lines: false

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

    token_column = current_token_column

    skip_space
    check :on_lbracket
    write "["
    next_token

    column = @column

    first_space = skip_space

    # Sometimes args comes with an array...
    if args && args[0].is_a?(Array)
      visit_literal_elements args, token_column: token_column
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
        write_space_using_setting(first_space, :never)
        needed_indent = column
      end

      if args
        indent(needed_indent) do
          visit args
        end
      end
    end

    skip_space_or_newline_using_setting(:never)

    check :on_rbracket
    write "]"
    next_token
  end

  def visit_sclass(node)
    # class << self
    #
    # [:sclass, target, body]
    _, target, body = node

    push_type(node) do
      consume_keyword "class"
      consume_space
      consume_op "<<"
      consume_space
      visit target

      @inside_type_body = true
      visit body
    end
  end

  def visit_setter(node)
    # foo.bar
    # (followed by `=`, though not included in this node)
    #
    # [:field, receiver, :".", name]
    _, receiver, _, name = node

    @dot_column = nil
    @original_dot_column = nil

    visit receiver

    skip_space_or_newline_using_setting(:no, @dot_column || next_indent)

    # Remember dot column
    dot_column = @column
    original_dot_column = current_token_column

    consume_call_dot

    skip_space_or_newline_using_setting(:no, next_indent)

    visit name

    # Only set it after we visit the call after the dot,
    # so we remember the outmost dot position
    @dot_column = dot_column
    @original_dot_column = original_dot_column
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
        visit_exps to_ary(node[1]), with_lines: false
      end
    end
  end

  def visit_lambda(node)
    # [:lambda, [:params, nil, nil, nil, nil, nil, nil, nil], [[:void_stmt]]]
    # [:lambda, [:params, nil, nil, nil, nil, nil, nil, nil], [[:@int, "1", [2, 2]], [:@int, "2", [3, 2]]]]
    # [:lambda, [:params, nil, nil, nil, nil, nil, nil, nil], [:bodystmt, [[:@int, "1", [2, 2]], [:@int, "2", [3, 2]]], nil, nil, nil]] (on 2.6.0)
    _, params, body = node

    body = body[1] if body[0] == :bodystmt
    check :on_tlambda
    write "->"
    next_token

    skip_space

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
    end

    if void_exps?(body)
      consume_space
      consume_token :on_tlambeg
      consume_space
      consume_token :on_rbrace
      return
    end

    consume_space

    brace = current_token_value == "{"

    if brace
      closing_brace_token, _ = find_closing_brace_token

      # Check if the whole block fits into a single line
      if current_token_line == closing_brace_token[0][0]
        consume_token :on_tlambeg

        consume_space
        visit_exps body, with_lines: false
        consume_space

        consume_token :on_rbrace
        return
      end

      consume_token :on_tlambeg
    else
      consume_keyword "do"
    end

    indent_body body, force_multiline: true

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

    base_column = current_token_column

    consume_keyword "super"

    if space?
      consume_space
      visit_command_end node, args, base_column
    else
      visit_call_at_paren node, args
    end
  end

  def visit_defined(node)
    # [:defined, exp]
    _, exp = node

    consume_keyword "defined?"
    has_space = space?

    if has_space
      consume_space
    else
      skip_space_or_newline
    end

    has_paren = current_token_kind == :on_lparen

    if has_paren && !has_space
      write "("
      next_token
      skip_space_or_newline
    end

    visit exp

    if has_paren && !has_space
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

  def visit_literal_elements(elements, inside_hash: false, inside_array: false, token_column:)
    base_column = @column
    base_line = @line
    needs_final_space = (inside_hash || inside_array) && space?
    first_space = skip_space

    if inside_hash
      needs_final_space = false
    end

    if inside_array
      needs_final_space = false
    end

    if newline? || comment?
      needs_final_space = false
    end

    # If there's a newline right at the beginning,
    # write it, and we'll indent element and always
    # add a trailing comma to the last element
    needs_trailing_comma = newline? || comment?
    if needs_trailing_comma
      if (call_info = @line_to_call_info[@line])
        call_info << true
      end

      needed_indent = next_indent
      indent { consume_end_of_line }
      write_indent(needed_indent)
    else
      needed_indent = base_column
    end

    wrote_comma = false
    first_space = nil

    elements.each_with_index do |elem, i|
      @literal_elements_level = @node_level

      is_last = last?(i, elements)
      wrote_comma = false

      if needs_trailing_comma
        indent(needed_indent) { visit elem }
      else
        visit elem
      end

      # We have to be careful not to aumatically write a heredoc on next_token,
      # because we miss the chance to write a comma to separate elements
      first_space = skip_space_no_heredoc_check
      indent(needed_indent) do
        wrote_comma = check_heredocs_in_literal_elements(is_last, wrote_comma)
      end
      next unless comma?

      unless is_last
        write ","
        wrote_comma = true
      end

      # We have to be careful not to aumatically write a heredoc on next_token,
      # because we miss the chance to write a comma to separate elements
      next_token_no_heredoc_check

      first_space = skip_space_no_heredoc_check
      indent(needed_indent) do
        wrote_comma = check_heredocs_in_literal_elements(is_last, wrote_comma)
      end

      if newline? || comment?
        if is_last
          # Nothing
        else
          indent(needed_indent) do
            consume_end_of_line(first_space: first_space)
            write_indent
          end
        end
      else
        write_space unless is_last
      end
    end
    @literal_elements_level = nil

    if needs_trailing_comma
      write "," unless wrote_comma || !trailing_commas || @last_was_heredoc

      consume_end_of_line(first_space: first_space)
      write_indent
    elsif comment?
      consume_end_of_line(first_space: first_space)
    else
      if needs_final_space
        consume_space
      else
        skip_space_or_newline
      end
    end

    if current_token_column == token_column && needed_indent < token_column
      # If the closing token is aligned with the opening token, we want to
      # keep it like that, for example in:
      #
      # foo([
      #       2,
      #     ])
      @literal_indents << [base_line, @line, token_column + INDENT_SIZE - needed_indent]
    elsif call_info && call_info[0] == current_token_column
      # If the closing literal position matches the column where
      # the call started, we want to preserve it like that
      # (otherwise we align it to the first parameter)
      call_info << @line
    end
  end

  def check_heredocs_in_literal_elements(is_last, wrote_comma)
    if (newline? || comment?) && !@heredocs.empty?
      if is_last && trailing_commas
        write "," unless wrote_comma
        wrote_comma = true
      end

      flush_heredocs
    end
    wrote_comma
  end

  def visit_if(node)
    visit_if_or_unless node, "if"
  end

  def visit_unless(node)
    visit_if_or_unless node, "unless"
  end

  def visit_if_or_unless(node, keyword, check_end: true)
    # if cond
    #   then_body
    # else
    #   else_body
    # end
    #
    # [:if, cond, then, else]
    line = @line

    consume_keyword(keyword)
    consume_space
    visit node[1]
    skip_space

    indent_body node[2]
    if (else_body = node[3])
      # [:else, else_contents]
      # [:elsif, cond, then, else]
      write_indent if @line != line

      case else_body[0]
      when :else
        consume_keyword "else"
        indent_body else_body[1]
      when :elsif
        visit_if_or_unless else_body, "elsif", check_end: false
      else
        bug "expected else or elsif, not #{else_body[0]}"
      end
    end

    if check_end
      write_indent if @line != line
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

    line = @line

    consume_keyword keyword
    consume_space

    visit cond

    indent_body body

    write_indent if @line != line
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
    written_space = false
    if semicolon?
      inline = true
      skip_semicolons

      if newline? || comment?
        inline = false
      else
        write ";"
        track_case_when
        write " "
        written_space = true
      end
    end

    if keyword?("then")
      inline = true
      next_token

      skip_space

      info = track_case_when
      skip_semicolons

      if newline?
        inline = false

        # Cancel tracking of `case when ... then` on a nelwine.
        @case_when_positions.pop
      else
        write_space unless written_space

        write "then"

        # We adjust the column and offset from:
        #
        #     when 1 then 2
        #           ^ (with offset 0)
        #
        # to:
        #
        #     when 1 then 2
        #                ^ (with offset 5)
        #
        # In that way we can align this with an `else` clause.
        if info
          offset = @column - info[1]
          info[1] = @column
          info[-1] = offset
        end

        write_space
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
        track_case_when
        first_space = skip_space

        if newline? || semicolon? || comment?
          # Cancel tracking of `else` on a nelwine.
          @case_when_positions.pop

          indent_body next_exp[1]
        else
          if align_case_when
            write_space
          else
            write_space_using_setting(first_space, :one)
          end
          visit_exps next_exp[1]
        end
      else
        visit next_exp
      end
    end
  end

  def consume_space(want_preserve_whitespace: false)
    first_space = skip_space
    if want_preserve_whitespace && !newline? && !comment? && first_space
      write_space first_space[2] unless @output[-1] == " "
      skip_space_or_newline
    else
      skip_space_or_newline
      write_space unless @output[-1] == " "
    end
  end

  def consume_space_or_newline
    skip_space
    if newline? || comment?
      consume_end_of_line
      write_indent(next_indent)
    else
      consume_space
    end
  end

  def skip_space
    first_space = space? ? current_token : nil
    next_token while space?
    first_space
  end

  def skip_ignored_space
    next_token while current_token_kind == :on_ignored_sp
  end

  def skip_space_no_heredoc_check
    first_space = space? ? current_token : nil
    while space?
      next_token_no_heredoc_check
    end
    first_space
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

  def skip_space_or_newline(_want_semicolon: false, write_first_semicolon: false)
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
          write_space
          write current_token_value.rstrip
          write "\n"
          write_indent(next_indent)
          @column = next_indent
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
  def consume_end_of_line(at_prefix: false, want_semicolon: false, want_multiline: true, needs_two_lines_on_comment: false, first_space: nil)
    found_newline = false               # Did we find any newline during this method?
    found_comment_after_newline = false # Did we find a comment after some newline?
    last = nil                          # Last token kind found
    multilple_lines = false             # Did we pass through more than one newline?
    last_comment_has_newline = false    # Does the last comment has a newline?
    newline_count = 0                   # Number of newlines we passed
    last_space = first_space            # Last found space

    loop do
      case current_token_kind
      when :on_sp
        # Ignore spaces
        last_space = current_token
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
          write_line
          if last == :comment && last_comment_has_newline
            multilple_lines = true
          else
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
          kind = current_token_kind
          unless [:on_ignored_nl, :on_eof].include?(kind)
            return if (kind == :on_kw) &&
                      (%w[class module def].include?(current_token_value))
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

          # If the last comment is in the previous line and it was already
          # aligned to this comment, keep it aligned. This is useful for
          # this:
          #
          # ```
          # a = 1 # some comment
          #       # that continues here
          # ```
          #
          # We want to preserve it like that and not change it to:
          #
          # ```
          # a = 1 # some comment
          # # that continues here
          # ```
          if current_comment_aligned_to_previous_one?
            write_indent(@last_comment_column)
            track_comment(match_previous_id: true)
          else
            write_indent
          end
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
            track_comment(id: @last_was_newline ? true : nil)
          else
            # If we didn't find any newline yet, this is the first comment,
            # so append a space if needed (for example after an expression)
            unless at_prefix
              # Preserve whitespace before comment unless we need to align them
              if last_space
                write last_space[2]
              else
                write_space
              end
            end

            # First we check if the comment was aligned to the previous comment
            # in the previous line, in order to keep them like that.
            if current_comment_aligned_to_previous_one?
              track_comment(match_previous_id: true)
            else
              # We want to distinguish comments that appear at the beginning
              # of a line (which means the line has only a comment) and comments
              # that appear after some expression. We don't want to align these
              # and consider them separate entities. So, we use `@last_was_newline`
              # as an id to distinguish that.
              #
              # For example, this:
              #
              #     # comment 1
              #       # comment 2
              #     call # comment 3
              #
              # Should format to:
              #
              #     # comment 1
              #     # comment 2
              #     call # comment 3
              #
              # Instead of:
              #
              #          # comment 1
              #          # comment 2
              #     call # comment 3
              #
              # We still want to track the first two comments to align to the
              # beginning of the line according to indentation in case they
              # are not already there.
              track_comment(id: @last_was_newline ? true : nil)
            end
          end
        end
        @last_comment = current_token
        @last_comment_column = @column
        last_comment_has_newline = current_token_value.end_with?("\n")
        last = :comment
        found_comment_after_newline = found_newline
        multilple_lines = false

        write current_token_value.rstrip
        next_token
      when :on_embdoc_beg
        if multilple_lines || last == :comment
          write_line
        end

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
       (multilple_lines && (want_multiline || found_comment_after_newline))
      write_line
    end
  end

  def consume_embedded_comment
    consume_token_value current_token_value
    next_token

    while current_token_kind != :on_embdoc_end
      consume_token_value current_token_value
      next_token
    end

    consume_token_value current_token_value.rstrip
    next_token
  end

  def consume_end
    return unless current_token_kind == :on___end__

    line = current_token_line

    write_line unless @output.empty?
    consume_token :on___end__

    lines = @code.lines[line..-1]
    lines.each do |current_line|
      write current_line.chomp
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
      @indent += INDENT_SIZE
      yield
      @indent -= INDENT_SIZE
    end
  end

  def indent_body(exps, force_multiline: false)
    first_space = skip_space

    has_semicolon = semicolon?

    if has_semicolon
      next_token
      skip_semicolons
      first_space = nil
    end

    # If an end follows there's nothing to do
    if keyword?("end")
      if has_semicolon
        write "; "
      else
        write_space_using_setting(first_space, :one)
      end
      return
    end

    # A then keyword can appear after a newline after an `if`, `unless`, etc.
    # Since that's a super weird formatting for if, probably way too obsolete
    # by now, we just remove it.
    has_then = keyword?("then")
    if has_then
      next_token
      second_space = skip_space
    end

    has_do = keyword?("do")
    if has_do
      next_token
      second_space = skip_space
    end

    # If no newline or comment follows, we format it inline.
    if !force_multiline && !(newline? || comment?)
      if has_then
        write " then "
      elsif has_do
        write_space_using_setting(first_space, :one, at_least_one: true)
        write "do"
        write_space_using_setting(second_space, :one, at_least_one: true)
      elsif has_semicolon
        write "; "
      else
        write_space_using_setting(first_space, :one, at_least_one: true)
      end
      visit_exps exps, with_indent: false, with_lines: false

      consume_space

      return
    end

    indent do
      consume_end_of_line(want_multiline: false)
    end

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
        visit_exps exps, with_indent: true
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

  def capture_output
    old_output = @output
    @output = +""
    yield
    result = @output
    @output = old_output
    result
  end

  def write(value)
    @output << value
    @last_was_newline = false
    @last_was_heredoc = false
    @column += value.size
  end

  def write_space(value = " ")
    @output << value
    @column += value.size
  end

  def write_space_using_setting(first_space, setting, at_least_one: false)
    if first_space && setting == :dynamic
      write_space first_space[2]
    elsif setting == :one || at_least_one
      write_space
    end
  end

  def skip_space_or_newline_using_setting(setting, indent_size = @indent)
    indent(indent_size) do
      first_space = skip_space
      if newline? || comment?
        consume_end_of_line(want_multiline: false, first_space: first_space)
        write_indent
      else
        write_space_using_setting(first_space, setting)
      end
    end
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
  end

  def indent_after_space(node, sticky: false, want_space: true, needed_indent: next_indent, token_column: nil, base_column: nil)
    skip_space

    case current_token_kind
    when :on_ignored_nl, :on_comment
      indent(needed_indent) do
        consume_end_of_line
      end

      if token_column && base_column && token_column == current_token_column
        # If the expression is aligned with the one above, keep it like that
        indent(base_column) do
          write_indent
          visit node
        end
      else
        indent(needed_indent) do
          write_indent
          visit node
        end
      end
    else
      if want_space
        write_space
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
    @indent + INDENT_SIZE
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

  def current_token_line
    current_token[0][0]
  end

  def current_token_column
    current_token[0][1]
  end

  def keyword?(keyword)
    current_token_kind == :on_kw && current_token_value == keyword
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
      _, kind = token
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

  def next_token
    prev_token = self.current_token

    @tokens.pop

    if (newline? || comment?) && !@heredocs.empty?
      flush_heredocs
    end

    # First first token in newline if requested
    if @want_first_token_in_line && prev_token && (prev_token[1] == :on_nl || prev_token[1] == :on_ignored_nl)
      @tokens.reverse_each do |token|
        case token[1]
        when :on_sp
          next
        else
          @first_token_in_line = token
          break
        end
      end
    end
  end

  def next_token_no_heredoc_check
    @tokens.pop
  end

  def last?(index, array)
    index == array.size - 1
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

  def push_type(node)
    old_type = @current_type
    @current_type = node
    yield
    @current_type = old_type
  end

  def to_ary(node)
    node[0].is_a?(Symbol) ? [node] : node
  end

  def dedent_calls
    return if @line_to_call_info.empty?

    lines = @output.lines

    while (line_to_call_info = @line_to_call_info.shift)
      first_line, call_info = line_to_call_info
      next unless call_info.size == 5

      indent, first_param_indent, needs_dedent, first_paren_end_line, last_line = call_info
      next unless needs_dedent
      next unless first_paren_end_line == last_line

      diff = first_param_indent - indent
      (first_line + 1..last_line).each do |line|
        @line_to_call_info.delete(line)

        next if @unmodifiable_string_lines[line]

        current_line = lines[line]
        current_line = current_line[diff..-1] if diff >= 0

        # It can happen that this line didn't need an indent because
        # it simply had a newline
        if current_line
          lines[line] = current_line
          adjust_other_alignments nil, line, 0, -diff
        end
      end
    end

    @output = lines.join
  end

  def indent_literals
    return if @literal_indents.empty?

    lines = @output.lines

    modified_lines = []
    @literal_indents.each do |first_line, last_line, indent|
      (first_line + 1..last_line).each do |line|
        next if @unmodifiable_string_lines[line]

        current_line = lines[line]
        current_line = "#{" " * indent}#{current_line}"
        unless modified_lines[line]
          modified_lines[line] = current_line
          lines[line] = current_line
          adjust_other_alignments nil, line, 0, indent
        end
      end
    end

    @output = lines.join
  end

  def do_align_case_when
    do_align @case_when_positions, :case
  end

  def do_align(components, scope)
    lines = @output.lines

    # Chunk components that are in consecutive lines
    chunks = components.chunk_while do |(l1, _c1, i1, id1), (l2, _c2, i2, id2)|
      l1 + 1 == l2 && i1 == i2 && id1 == id2
    end

    chunks.each do |elements|
      next if elements.size == 1

      max_column = elements.map { |_l, c| c }.max

      elements.each do |(line, column, _, _, offset)|
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

      target[index][1] += offset if target[index]
    end
  end

  def remove_lines_before_inline_declarations
    return if @inline_declarations.empty?

    lines = @output.lines

    @inline_declarations.reverse.each_cons(2) do |(after, after_original), (before, before_original)|
      if before + 2 == after && before_original + 1 == after_original && lines[before + 1].strip.empty?
        lines.delete_at(before + 1)
      end
    end

    @output = lines.join
  end

  def result
    @output
  end

  # Check to see if need to add space inside hash literal braces.
  def need_space_for_hash?(node, closing_brace_token)
    return false unless node[1]

    left_need_space = current_token_line == node_line(node, beginning: true)
    right_need_space = closing_brace_token[0][0] == node_line(node, beginning: false)

    left_need_space && right_need_space
  end

  def node_line(node, beginning: true)
    return if node.nil?
    # get line of node, it is only used in visit_hash right now,
    # so handling the following node types is enough.
    case node.first
    when :hash, :string_literal, :symbol_literal, :symbol, :vcall, :string_content, :assoc_splat, :var_ref
      node_line(node[1], beginning: beginning)
    when :assoc_new
      # There's no line number info for empty strings or hashes.
      if node[1] != EMPTY_STRING && node[1] != EMPTY_HASH
        node_line(node[1], beginning: beginning)
      elsif node.last != EMPTY_STRING && node.last != EMPTY_HASH
        node_line(node.last, beginning: beginning)
      else
        return
      end
    when :assoclist_from_args
      node_line(beginning ? node[1][0] : node[1].last, beginning: beginning)
    when :dyna_symbol
      if node[1][0].is_a?(Symbol)
        node_line(node[1], beginning: beginning)
      else
        node_line(node[1][0], beginning: beginning)
      end
    when :@label, :@int, :@ident, :@tstring_content, :@kw
      node[2][0]
    end
  end
end
