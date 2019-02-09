# frozen_string_literal: true

require "ripper"

class Rufo::Formatter
  include Rufo::Settings

  B = Rufo::DocBuilder
  INDENT_SIZE = 2
  COMMA_DOC = B.concat([",", B::LINE])

  attr_reader :squiggly_flag

  def self.format(code, **options)
    formatter = new(code, **options)
    formatter.format
    formatter.result
  end

  def initialize(code, **options)
    @squiggly_flag = false
    @code = code
    @tokens = Ripper.lex(code).reverse!
    @sexp = Ripper.sexp(code)

    unless @sexp
      raise ::Rufo::SyntaxError.new
    end

    @line = 0
    @last_was_newline = true
    @output = +""

    # Heredocs list, associated with calls ([heredoc, tilde])
    @heredocs = []

    # The current heredoc being printed
    @current_heredoc = nil

    # This is used to track how far deep we are in the AST.
    # This is useful as it allows you to check if you are inside an array
    # when dealing with heredocs.
    @node_level = 0

    # This represents the node level of the most recent literal elements list.
    # It is used to track if we are in a list of elements so that commas
    # can be added appropriately for heredocs for example.
    @literal_elements_level = nil

    # A stack to keeping track of if a inner group has needs to break.
    # Example:
    # [
    #   [
    #     <<-HEREDOC
    #     HEREDOC
    #   ]
    # ]
    # The inner array needs to break so the outer array must also break.
    @inner_group_breaks = []

    init_settings(options)
  end

  def format
    result = visit @sexp
    result = B.concat([result, consume_end])
    the_output = Rufo::DocPrinter.print_doc_to_string(
      result, {print_width: print_width }
    )[:formatted]
    @output = the_output

    @output << "\n" if !@output.end_with?("\n") || @output == ""
    @output.chomp! if @output.end_with?("\n\n")
    @output = @output[1..-1] if @output.start_with?("\n\n")
  end

  def visit(node)
    @node_level += 1
    unless node.is_a?(Array)
      bug "unexpected node: #{node} at #{current_token}"
    end
    result = visit_doc(node)
    return result
  ensure
    @node_level -= 1
  end

  # [:retry]
  # [:redo]
  # [:zsuper]
  KEYWORDS = {
    retry: "retry",
    redo: "redo",
    zsuper: "super",
    return0: "return",
    yield0: "yield",
  }

  # [:return, exp]
  # [:break, exp]
  # [:next, exp]
  # [:yield, exp]
  CONTROL_KEYWORDS = [
    :return,
    :break,
    :next,
    :yield,
  ]

  # [:@gvar, "$abc", [1, 0]]
  # [:@backref, "$1", [1, 0]]
  # [:@op, "*", [1, 1]]
  # [:@label, "foo:", [1, 3]]
  SIMPLE_NODE = [
    :@gvar,
    :@backref,
    :@op,
    :@label,
  ]

  def visit_doc(node)
    type = node.first
    if KEYWORDS.has_key?(type)
      return skip_keyword(KEYWORDS[type])
    end

    if SIMPLE_NODE.include?(type)
      next_token
      return node[1]
    end

    if CONTROL_KEYWORDS.include?(type)
      return visit_control_keyword node, type.to_s
    end

    case type
    when :program
      # Topmost node
      #
      # [:program, exps]
      return visit_exps_doc node[1]
    when :array
      return visit_array(node)
    when :args_add_star
      return visit_args_add_star_doc(node)
    when :hash
      return visit_hash(node)
    when :assoc_new
      return visit_hash_key_value(node)
    when :alias, :var_alias
      return visit_alias(node)
    when :sclass
      return visit_sclass(node)
    when :const_path_ref, :const_path_field
      return visit_path(node)
    when :top_const_ref, :top_const_field
      # [:top_const_ref, [:@const, "Foo", [1, 2]]]
      next_token # "::"
      return B.concat(["::", visit(node[1])])
    when :symbol_literal
      return visit_symbol_literal(node)
    when :symbol
      return visit_symbol(node)
    when :ifop
      return visit_ternary_if(node)
    when :bodystmt
      return visit_bodystmt_doc(node)
    when :class
      return visit_class(node)
    when :begin
      return visit_begin(node)
    when :mrhs_new_from_args
      return visit_mrhs_new_from_args(node)
    when :brace_block
      return visit_brace_block(node)
    when :BEGIN
      return visit_begin_node(node)
    when :END
      return visit_end_node(node)
    when :for
      return visit_for(node)
    when :mlhs_add_star
      return visit_mlhs_add_star(node)
    when :undef
      return visit_undef(node)
    when :defined
      return visit_defined(node)
    when :super
      return visit_super(node)
    when :lambda
      return visit_lambda(node)
    when :field
      return visit_setter(node)
    when :aref_field
      return visit_array_setter(node)
    when :aref
      return visit_array_access(node)
    when :args_add_block
      return visit_call_args(node)
    when :method_add_arg
      return visit_call_without_receiver(node)
    when :regexp_literal
      return visit_regexp_literal(node)
    when :dot2
      return visit_range(node, true)
    when :dot3
      return visit_range(node, false)
    when :assoc_splat
      return visit_splat_inside_hash(node)
    when :params
      return visit_params(node)
    when :paren
      return visit_paren(node)
    when :def
      return visit_def(node)
    when :defs
      return visit_def_with_receiver(node)
    when :mrhs_add_star
      return visit_mrhs_add_star(node)
    when :mlhs
      return visit_mlhs(node)
    when :mlhs_paren
      return visit_mlhs_paren(node)
    when :block_var
      return visit_block_arguments(node)
    when :module
      return visit_module(node)
    when :binary
      return visit_binary(node)
    when :unary
      return visit_unary(node)
    when :case
      return visit_case(node)
    when :when
      return visit_when(node)
    when :until
      return visit_until(node)
    when :while
      return visit_while(node)
    when :unless
      return visit_unless(node)
    when :if
      return visit_if(node)
    when :do_block
      return visit_do_block(node)
    when :call
      return visit_call_with_receiver(node)
    when :method_add_block
      return visit_call_with_block(node)
    when :bare_assoc_hash
      # [:bare_assoc_hash, exps]
      return visit_comma_separated_list_doc(node[1])
    when :command_call
      return visit_command_call(node)
    when :command
      return visit_command(node)
    when :if_mod
      return visit_suffix(node, "if")
    when :unless_mod
      return visit_suffix(node, "unless")
    when :while_mod
      return visit_suffix(node, "while")
    when :until_mod
      return visit_suffix(node, "until")
    when :rescue_mod
      return visit_suffix(node, "rescue")
    when :assign
      return visit_assign(node)
    when :opassign
      return visit_op_assign(node)
    when :massign
      return visit_multiple_assign(node)
    when :const_ref
      # [:const_ref, [:@const, "Foo", [1, 8]]]
      return visit node[1]
    when :vcall
      # [:vcall, exp]
      return visit node[1]
    when :fcall
      # [:fcall, [:@ident, "foo", [1, 0]]]
      return visit node[1]
    when :@kw
      # [:@kw, "nil", [1, 0]]
      return skip_token :on_kw
    when :@ivar
      # [:@ivar, "@foo", [1, 0]]
      return skip_token :on_ivar
    when :@cvar
      # [:@cvar, "@@foo", [1, 0]]
      return skip_token :on_cvar
    when :@const
      # [:@const, "FOO", [1, 0]]
      return skip_token :on_const
    when :@ident
      return skip_token :on_ident
    when :var_ref, :var_field
      # [:var_ref, exp]
      return visit node[1]
    when :dyna_symbol
      return visit_quoted_symbol_literal(node)
    when :@int
      # Integer literal
      #
      # [:@int, "123", [1, 0]]
      return skip_token :on_int
    when :@float
      # Float literal
      #
      # [:@int, "123.45", [1, 0]]
      return skip_token :on_float
    when :@rational
      # Rational literal
      #
      # [:@rational, "123r", [1, 0]]
      return skip_token :on_rational
    when :@imaginary
      # Imaginary literal
      #
      # [:@imaginary, "123i", [1, 0]]
      return skip_token :on_imaginary
    when :@CHAR
      # [:@CHAR, "?a", [1, 0]]
      return skip_token :on_CHAR
    when :@backtick
      # [:@backtick, "`", [1, 4]]
      return skip_token :on_backtick
    when :string_dvar
      return visit_string_dvar(node)
    when :string_embexpr
      # String interpolation piece ( #{exp} )
      return visit_string_interpolation node
    when :string_content
      # [:string_content, exp]
      return visit_exps_doc node[1..-1], with_lines: false
    when :string_concat
      return visit_string_concat node
    when :@tstring_content
      return visit_string_content(node)
    when :string_literal, :xstring_literal
      return visit_string_literal node
    when :synthetic_block_ident
      return visit_synthetic_block_ident(node)
    when :synthetic_star
      return visit_synthetic_star(node)
    when :rest_param
      return visit_rest_param(node)
    when :kwrest_param
      return visit_kwrest_param(node)
    else
      bug "Unhandled node: #{node}"
    end
  end

  def visit_synthetic_star(node)
    _, ident = node
    skip_op "*"
    return B.concat(["*", visit(ident)])
  end

  def visit_synthetic_block_ident(node)
    _, ident = node
    skip_space_or_newline
    if comma?
      skip_comma_and_spaces
    end
    skip_space_or_newline
    skip_op "&"
    skip_space_or_newline
    block_doc = visit(ident)
    B.concat(['&', block_doc])
  end

  def visit_string_content(_node)
    # [:@tstring_content, "hello ", [1, 1]]
    doc = []
    heredoc, tilde = @current_heredoc
    if heredoc && tilde && broken_ripper_version?
      @squiggly_flag = true
    end

    if heredoc && tilde && @last_was_newline
      skip_ignored_space
      if current_token_kind == :on_tstring_content
        doc << skip_token(:on_tstring_content)
      end
    else
      while (current_token_kind == :on_ignored_sp) ||
            (current_token_kind == :on_tstring_content) ||
            (current_token_kind == :on_embexpr_beg)
        check current_token_kind
        break if current_token_kind == :on_embexpr_beg
        doc << skip_token(current_token_kind)
      end
    end
    if doc.last.is_a?(String) && doc.last[-1] == "\n"
      doc[-1] = doc.last.rstrip
      if doc.all?(&:empty?)
        doc << B::DOUBLE_SOFT_LINE
      else
        doc << B::SOFT_LINE
      end
      @last_was_newline = true
    end
    B.concat(doc)
  end

  def handle_space_or_newline_doc(doc, with_lines: true, newline_limit: Float::INFINITY)
    comments, newline_before_comment, _, num_newlines = skip_space_or_newline(newline_limit)
    comments_added = add_comments_on_line(doc, comments, newline_before_comment: newline_before_comment)
    return comments_added unless with_lines
    doc << B::LINE_SUFFIX_BOUNDARY if num_newlines == 0
    comments_added
  end

  def visit_exps_doc(exps, with_lines: true)
    doc = []
    handle_space_or_newline_doc(doc, with_lines: with_lines)

    exps.each do |exp|
      exp_kind = exp[0]

      # Skip voids to avoid extra indentation
      if exp_kind == :void_stmt
        handle_space_or_newline_doc(doc)
        next
      end

      handle_space_or_newline_doc(doc, with_lines: with_lines)
      doc << visit(exp)

      if with_lines

        if needs_two_lines?(exp) && add_if_not_present(doc, B::DOUBLE_SOFT_LINE, type: :line)
          # We have added a double line so we need to make sure that the
          # comment does not start with a single line.
          comment_doc = []
          handle_space_or_newline_doc(comment_doc, with_lines: with_lines)
          while comment_doc.first.is_a?(Hash) && comment_doc.first[:type] == :line
            comment_doc.shift
          end
          doc.concat(comment_doc)
          next
        end
        handle_space_or_newline_doc(doc, with_lines: false)
        add_if_not_present(doc, B::LINE, type: :line)
      else
        handle_space_or_newline_doc(doc, with_lines: with_lines)
        next
      end
    end
    handle_space_or_newline_doc(doc, with_lines: with_lines)
    B.concat(doc)
  end

  def visit_exps_doc_no_newlines(exps)
    doc = []

    exps.each do |exp|
      doc << visit(exp)
    end
    B.concat(doc)
  end

  def add_if_not_present(doc, doc_element, type:)
    last_el = doc.last
    if !last_el.is_a?(Hash) || last_el[:type] != type
      doc << doc_element
      true
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

  def visit_string_literal(node, bail_on_heredoc: false)
    # [:string_literal, [:string_content, exps]]
    heredoc = current_token_kind == :on_heredoc_beg
    tilde = current_token_value.include?("~")
    dash = current_token_value.include?("-")

    doc = []

    if heredoc
      doc << current_token_value.rstrip
      # Accumulate heredoc: we'll write it once
      # we find a newline.
      @heredocs << [node, tilde, dash]
      # Get the next_token while capturing any output.
      # This is needed so that we can add a comma if one is not already present.
      if bail_on_heredoc
        next_token_no_heredoc_check
        return
      end
      h_doc, _ = next_token
      h_doc ||=[]

      inside_literal_elements_list = !@literal_elements_level.nil? &&
                                     [2, 3].include?(@node_level - @literal_elements_level)
      needs_comma = !comma? && trailing_commas

      if inside_literal_elements_list && needs_comma
        doc << ","
        @last_was_heredoc = true
      end
      doc << B.concat(h_doc)
      return B.concat(doc)
    elsif current_token_kind == :on_backtick
      doc << skip_token(:on_backtick)
    else
      simple_doc = format_simple_string(node)
      return B.concat(simple_doc) if simple_doc
      doc << skip_token(:on_tstring_beg)
    end

    doc << visit_string_literal_end(node)
    B.concat(doc)
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
    doc = [quote_char]
    next_token
    inner = node[1][1..-1]
    doc << visit_exps_doc(inner, with_lines: false)
    doc << quote_char
    next_token

    doc
  end

  def visit_string_literal_end(node)
    inner = node[1]
    inner = inner[1..-1] unless node[0] == :xstring_literal
    doc = []
    doc << visit_exps_doc(inner, with_lines: false)

    case current_token_kind
    when :on_heredoc_end
      heredoc, tilde, dash = @current_heredoc
      if heredoc && tilde
        doc = [
          B.group(
            B.indent(B.concat([B::LINE, doc.first])),
            should_break: true
          ),
          B::HARD_LINE,
          current_token_value.strip
        ]
      elsif heredoc && dash
          doc << B::HARD_LINE
          doc << current_token_value.strip
      elsif heredoc
        doc.last[:parts].first[:parts].pop
        doc << B::LITERAL_LINE
        doc << current_token_value.rstrip
      end
      next_token
      skip_space

      # Simulate a newline after the heredoc
      @tokens << [[0, 0], :on_ignored_nl, "\n"]
    when :on_backtick
      doc << skip_token(:on_backtick)
    else
      doc << skip_token(:on_tstring_end)
    end
    B.concat(doc)
  end

  def visit_string_concat(node)
    # string1 string2
    # [:string_concat, string1, string2]
    _, string1, string2 = node

    doc = [visit(string1)]


    has_backslash, _ = skip_space_backslash
    if has_backslash
      doc << " \\"
      doc << B::SOFT_LINE
    else
      skip_space
      doc << " "
    end

    doc << visit(string2)
    B.group(B.concat([B.indent(B.concat(doc))]), should_break: true)
  end

  def visit_string_interpolation(node)
    # [:string_embexpr, exps]
    doc = [skip_token(:on_embexpr_beg)]
    handle_space_or_newline_doc(doc)
    while doc.last.is_a?(Hash) && doc.last[:type] == :line
      doc.pop
    end
    if current_token_kind == :on_tstring_content
      next_token
    end
    doc << visit_exps_doc(node[1], with_lines: false)
    handle_space_or_newline_doc(doc)
    doc << skip_token(:on_embexpr_end)
    B.concat(doc)
  end

  def visit_string_dvar(node)
    # [:string_dvar, [:var_ref, [:@ivar, "@foo", [1, 2]]]]
    doc = [skip_token(:on_embvar), visit(node[1])]
    B.concat(doc)
  end

  def visit_mlhs(node)
    # [:mlsh, *args]
    _, *args = node

    visit_mlhs_or_mlhs_paren(args)
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
    B.concat([skip_token(:on_symbeg), visit_exps_doc_no_newlines(node[1..-1])])
  end

  def visit_quoted_symbol_literal(node)
    # :"foo"
    #
    # [:dyna_symbol, exps]
    _, exps = node

    # This is `"...":` as a hash key
    if current_token_kind == :on_tstring_beg

      doc = [skip_token(:on_tstring_beg), visit(exps), skip_token(:on_label_end)]
    else
      doc = [skip_token(:on_symbeg), visit_exps_doc( exps, with_lines: false), skip_token(:on_tstring_end)]
    end
    B.concat(doc)
  end

  def visit_path(node)
    # Foo::Bar
    #
    # [:const_path_ref,
    #   [:var_ref, [:@const, "Foo", [1, 0]]],
    #   [:@const, "Bar", [1, 5]]]
    pieces = node[1..-1]
    doc = []
    pieces.each_with_index do |piece, i|
      doc << visit(piece)
      unless last?(i, pieces)
        next_token # "::"
        skip_space_or_newline
      end
    end
    B.join('::', doc)
  end

  def visit_assign(node)
    # target = value
    #
    # [:assign, target, value]
    _, target, value = node

    doc = [visit(target), " ="]
    skip_space

    skip_op("=")
    should_break = visit_assign_value_with_comment(doc, value)
    B.group(B.concat(doc), should_break: should_break)
  end

  def visit_assign_value_with_comment(doc, value)
    should_break = comment_break = handle_space_or_newline_doc(doc, with_lines: false)
    value_doc = visit_assign_value(value)
    if value_doc.is_a?(Hash)
      should_break ||= value_doc[:parts] && value_doc[:parts].length > 1
    end
    if comment_break
      value_doc = B.indent(B.concat([B::LINE, value_doc]))
    else
      value_doc = B.concat([" ", value_doc])
    end
    doc << value_doc
    should_break
  end

  def visit_op_assign(node)
    # target += value
    #
    # [:opassign, target, op, value]
    _, target, op, value = node

    before = op[1][0...-1]
    after = op[1][-1]

    doc = [visit(target), " ", before, after]

    skip_space

    # [:@op, "+=", [1, 2]],
    check :on_op

    next_token
    should_break = visit_assign_value_with_comment(doc, value)

    B.group(B.concat(doc), should_break: should_break)
  end

  def visit_multiple_assign(node)
    # [:massign, lefts, right]
    _, lefts, right = node
    doc = []
    with_multiple_assignments {
      doc << visit_comma_separated_list_doc(lefts)
    }
    doc << " ="
    skip_space

    # A trailing comma can come after the left hand side
    if comma?
      skip_token :on_comma
      skip_space
    end

    skip_op "="
    should_break = visit_assign_value_with_comment(doc, right)
    B.group(B.concat(doc), should_break: should_break)
  end

  def with_multiple_assignments
    old_value = @in_multiple_assignment
    @in_multiple_assignment = true
    yield
  ensure
    @in_multiple_assignment = old_value
  end

  def in_multiple_assignment?
    !!@in_multiple_assignment
  end

  def visit_assign_value(value)
    skip_space_backslash
    visit(value)
  end

  def visit_ternary_if(node)
    # cond ? then : else
    #
    # [:ifop, cond, then_body, else_body]
    _, cond, then_body, else_body = node
    doc = [
      visit(cond),
      " ",
      "?",
    ]

    skip_space
    skip_op "?"
    skip_space_or_newline
    doc_if_true = [
      B::LINE,
      visit(then_body),
      " ",
      ":",
    ]
    skip_space
    skip_op ":"
    skip_space_or_newline
    doc_if_true << B.concat([B::LINE, visit(else_body)])
    doc << B.indent(B.concat(doc_if_true))
    B.group(B.concat(doc))
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

    doc = [visit(body), ' ', suffix, " "]
    skip_space
    skip_keyword(suffix)
    handle_space_or_newline_doc(doc)
    doc << visit(cond)
    B.concat(doc)
  end

  def visit_call_with_receiver_cmps(node)
    # [:call, obj, :".", name]
    _, obj, _text, name = node
    doc = [visit(obj)]

    skip_space
    should_break = handle_space_or_newline_doc(doc, with_lines: false)
    call_doc = [B::SOFT_LINE, skip_call_dot]

    should_break ||= handle_space_or_newline_doc(call_doc, with_lines: false)

    if name == :call
      # :call means it's .()
      name_doc = ""
    else
      name_doc = visit(name)
    end
    [doc, call_doc, name_doc, should_break]
  end

  def visit_call_with_receiver(node)
    receiver_doc, call_doc, name_doc, should_break = visit_call_with_receiver_cmps(node)
    doc = receiver_doc

    call_doc << name_doc
    doc << B.indent(B.concat(call_doc))

    B.group(B.concat(doc), should_break: should_break)
  end

  def skip_call_dot
    if current_token_kind == :on_op
      skip_token :on_op
    else
      skip_token :on_period
    end
  end

  def visit_call_without_receiver(node)
    # foo(arg1, ..., argN)
    #
    # [:method_add_arg,
    #   [:fcall, [:@ident, "foo", [1, 0]]],
    #   [:arg_paren, [:args_add_block, [[:@int, "1", [1, 6]]], false]]]
    _, name, args = node

    # byebug
    if name.first != :call
      doc = [visit(name)]
      return B.concat(doc) if args.empty?
      doc << visit_call_at_paren(node, args)
      return B.concat(doc)
    end
    receiver_doc, call_doc, name_doc, should_break = visit_call_with_receiver_cmps(name)
    doc = receiver_doc

    parens_doc = visit_call_at_paren(node, args)
    doc << B.indent(B.concat([*call_doc, (B.concat([name_doc, parens_doc]))]))
    B.group(B.concat(doc), should_break: should_break)
  end

  def visit_call_at_paren(_node, args)
    skip_token :on_lparen
    doc = ["("]
    # If there's a trailing comma then comes [:arg_paren, args],
    # which is a bit unexpected, so we fix it
    if args[1].is_a?(Array) && args[1][0].is_a?(Array)
      args_node = [:args_add_block, args[1], false]
    else
      args_node = args[1]
    end

    skip_space

    if args_node
      doc << visit_call_args(args_node, indent_all: true)
      skip_space
    end

    skip_comma_and_spaces if comma?
    handle_space_or_newline_doc(doc)
    while doc.last.is_a?(Hash) && doc.last[:type] == :line
      doc.pop
    end
    # skipping token adds )
    h_doc, _ = skip_token :on_rparen
    doc << h_doc
    B.concat(doc)
  end

  def visit_command(node)
    # foo arg1, ..., argN
    #
    # [:command, name, args]
    _, name, args = node

    doc = [visit(name), " "]

    doc << visit_command_args_doc(args)
    B.concat(doc)
  end

  def flush_heredocs_doc
    doc = []
    comment = nil
    if comment?
      comment = current_token_value.rstrip
      next_token
    end

    until @heredocs.empty?
      heredoc_info = @heredocs.first

      @heredocs.shift
      @current_heredoc = heredoc_info
      doc << visit_string_literal_end(heredoc_info.first)
      @current_heredoc = nil
      printed = true
    end

    @last_was_heredoc = true if printed
    if doc.count > 1
      doc = [B::LITERAL_LINE, B.join(B::LITERAL_LINE, doc)]
    elsif doc.count == 1
      doc.unshift(B::LITERAL_LINE)
    end
    [doc, comment]
  end

  def visit_command_call(node)
    # [:command_call,
    #   receiver
    #   :".",
    #   name
    #   [:args_add_block, [[:@int, "1", [1, 8]]], block]]
    _, receiver, _, name, args = node

    doc = [visit(receiver)]
    should_break = handle_space_or_newline_doc(doc)

    call_doc = [skip_call_dot]

    skip_space

    should_break ||= handle_space_or_newline_doc(call_doc)

    call_doc << visit(name)
    call_doc << " "

    call_doc << visit_command_args_doc(args)
    doc << B.concat(call_doc)

    B.group(B.indent(B.concat(doc)), should_break: should_break)
  end

  def visit_command_args_doc(args)
    if args.first != :args_add_block
      args = [:args_add_block, args]
    end
    visit_call_args args, include_trailing_comma: false
  end

  def visit_call_with_block(node)
    # [:method_add_block, call, block]
    _, call, block = node
    doc = [visit(call), " "]

    skip_space

    doc << visit(block)

    B.concat(doc)
  end

  def visit_brace_block(node)
    # [:brace_block, args, body]
    _, args, body = node
    doc = []
    # This is for the empty `{ }` block
    if void_exps?(body)
      doc << "{"
      skip_token :on_lbrace
      if args && !args.empty?
        doc << consume_block_args_doc(args)
      end
      skip_space
      skip_token :on_rbrace
      doc << B::LINE
      doc << "}"
      return B.group(B.concat(doc), should_break: false)
    end

    # Otherwise it's multiline
    skip_token :on_lbrace
    doc << B.if_break("do", "{")
    doc << consume_block_args_doc(args)
    body_doc = nil
    included_a_comment = with_comment_check {
      body_doc = indent_body_doc(body, force_multiline: true)
    }

    remove_unneeded_parts(body_doc)
    doc << B.indent(B.concat([B::LINE, body_doc]))

    skip_token :on_rbrace
    doc << B::LINE
    doc << B.if_break("end", "}")
    B.group(B.concat(doc), should_break: body.length > 1 || included_a_comment)
  end

  def with_comment_check
    old_value = @contains_comment
    yield
    current_value = @contains_comment
    current_value
  ensure
    @contains_comment = old_value
  end

  def set_contains_comment
    @contains_comment = true
  end

  def visit_do_block(node)
    # [:brace_block, args, body]
    _, args, body = node
    doc = ["do"]

    skip_keyword "do"

    doc << consume_block_args_doc(args)
    handle_space_or_newline_doc(doc)

    if body.first == :bodystmt
      doc << visit_bodystmt_doc(body)
    else
      doc << B.indent(B.concat([B::LINE, indent_body_doc(body)]))
      doc << B::LINE
      doc << "end"
      skip_keyword "end"
    end
    B.concat(doc)
  end

  def consume_block_args_doc(args)
    if args
      skip_space_or_newline
      # + 1 because of |...|
      #                ^
      return visit(args)
    end
    return B.concat([])
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
      return B.concat([])
    end

    doc = [" |"]
    skip_token :on_op
    skip_space_or_newline

    unless empty_params
      doc << visit(params)
      skip_space
    end

    if local_params
      if semicolon?
        skip_token :on_semicolon
        skip_space
      end
      doc << "; "

      doc << visit_comma_separated_list_doc(local_params)
    else
      skip_space_or_newline
    end

    skip_op "|"
    doc << "|"
    B.concat(doc)
  end

  def visit_call_arg_list(args, include_trailing_comma: )
    flattened_args = []
    args.each do |arg|
      type, _ = arg
      if type == :bare_assoc_hash
        arg[1].each {|n|  flattened_args << n }
      else
        flattened_args << arg
      end
    end
    should_break, doc = visit_comma_separated_list_doc_no_group(flattened_args, include_trailing_comma: include_trailing_comma)
    [should_break, doc]
  end

  def visit_call_args(node, indent_all: false, include_trailing_comma: trailing_commas)
    # [:args_add_block, args, block]
    _, args, block_arg = node
    pre_comments_doc = []
    args_doc = []
    should_break = handle_space_or_newline_doc(pre_comments_doc, with_lines: false)

    new_args = [*args]
    if block_arg
      new_args << [:synthetic_block_ident, block_arg[1]]
    end

    if !new_args.empty?
      if new_args[0] == :args_add_star
        # arg1, ..., *star
        doc = visit(new_args)
        args_doc << doc
      else
        needs_break, doc = visit_call_arg_list(new_args, include_trailing_comma: include_trailing_comma)
        should_break ||= needs_break
        args_doc << doc
      end
    end

    if indent_all
      B.group(
        B.concat([
          B.indent(B.concat([
            B::SOFT_LINE,
            *pre_comments_doc,
            B::LINE_SUFFIX_BOUNDARY,
            *args_doc,
          ])),
          B::SOFT_LINE,
        ]),
        should_break: should_break
      )
    else
      args_doc = args_doc.first[:parts]
      while args_doc.first.is_a?(Hash) && args_doc.first[:type] == :line_suffix_boundary
        args_doc.shift
      end
      first_line_index = args_doc.index { |i| i.is_a?(Hash) && i[:type] == :line } || args_doc.length
      first_items = args_doc[0..first_line_index]
      args_doc = args_doc[first_line_index..-1]
      args_doc.shift if args_doc.first.is_a?(Hash) && args_doc.first[:type] == :line
      remaining_doc = []
      unless args_doc.empty?
        remaining_doc = [
          B.indent(
            B.concat([
              B::SOFT_LINE,
              *args_doc
            ])
          ),
          B::SOFT_LINE
        ]
      end
      B.group(
        B.concat([
          *pre_comments_doc,
          B::LINE_SUFFIX_BOUNDARY,
          *first_items,
          *remaining_doc
        ]),
        should_break: should_break
      )
    end
  end

  def skip_comma_and_spaces
    skip_space
    check :on_comma
    next_token
    skip_space
  end

  def visit_args_add_star_doc(node)
    # [:args_add_star, args, star, post_args]
    _, args, star, *post_args = node
    doc = []
    if !args.empty? && args[0] == :args_add_star
      # arg1, ..., *star
      doc << visit(args)
    else
      pre_doc = visit_literal_elements_simple_doc(args)
      doc.concat(pre_doc)
    end

    skip_space
    skip_comma_and_spaces if comma?

    skip_op "*"
    doc << B.concat(["*", visit(star)])

    if post_args && !post_args.empty?
      skip_comma_and_spaces
      post_doc = visit_literal_elements_simple_doc(post_args)
      doc.concat(post_doc)
    end
    B.join(', ', doc)
  end

  def visit_begin(node)
    # begin
    #   body
    # end
    #
    # [:begin, [:bodystmt, body, rescue_body, else_body, ensure_body]]
    skip_keyword "begin"
    B.concat([
      "begin",
      visit(node[1])
    ])
  end

  def remove_unneeded_parts(doc)
    parts = doc[:parts]
    index = parts.rindex { |p| !p.is_a?(Hash) || p[:type] != :line_suffix_boundary && p[:type] != :line }
    if index.nil?
      doc[:parts] = []
      return
    end
    if parts.last[:type] == :line_suffix_boundary && parts[-2][:type] == :line
      parts.pop
      parts.pop
    end
  end

  def visit_bodystmt_doc(node)
    # [:bodystmt, body, rescue_body, else_body, ensure_body]
    # [:bodystmt, [[:@int, "1", [2, 1]]], nil, [[:@int, "2", [4, 1]]], nil] (2.6.0)
    _, body, rescue_body, else_body, ensure_body = node

    result = visit_exps_doc(body)
    remove_unneeded_parts(result)
    if result[:parts].empty?
      doc = [B::LINE]
    else
      doc = [
        B.indent(B.concat([
          B::LINE,
          result
        ])),
        B::LINE
      ]
    end

    while rescue_body
      # [:rescue, type, name, body, more_rescue]
      _, type, name, body, more_rescue = rescue_body
      rescue_statement_doc = [B::LINE, "rescue"]
      # write_indent
      skip_keyword "rescue"
      if type
        skip_space
        rescue_statement_doc << " "
        rescue_statement_doc << visit_rescue_types_doc(type)
      end

      if name
        skip_space
        rescue_statement_doc << " "
        skip_op "=>"
        rescue_statement_doc << "=>"
        skip_space
        rescue_statement_doc << " "
        rescue_statement_doc << visit(name)
      end
      rescue_statement_doc << B::LINE
      rescue_body = more_rescue
      doc << B.concat([
        B.concat(rescue_statement_doc),
        B.indent(B.concat([B::LINE, visit_exps_doc(body)]))
      ])
    end

    if else_body
      # [:else, body]
      skip_keyword "else"
      doc << "else"
      doc << B.indent(visit_exps_doc(else_body[1]))
    end

    if ensure_body
      # [:ensure, body]
      skip_keyword "ensure"
      doc << B.concat([
        B.concat(["ensure", B::LINE]),
        B.indent(B.concat([B::LINE, visit_exps_doc(ensure_body[1])]))
      ])
    end

    skip_space_or_newline
    doc << B::SOFT_LINE

    skip_keyword "end"
    doc << "end"
    comments, newline_before_comment = skip_space_or_newline
    add_comments_on_line(doc, comments, newline_before_comment: newline_before_comment)
    doc << B::LINE_SUFFIX_BOUNDARY
    B.concat(doc)
  end

  def visit_rescue_types_doc(node)
    if node.first.is_a?(Array)
      visit_comma_separated_list_doc(node)
    else
      visit node
    end
  end

  def visit_mrhs_new_from_args(node)
    # Multiple exception types
    # [:mrhs_new_from_args, exps, final_exp]
    _, exps, final_exp = node
    if final_exp
      exp_list = [*exps, final_exp]
    else
      exp_list = to_ary(exps)
    end
    visit_comma_separated_list_doc(exp_list)
  end

  def visit_mlhs_paren(node)
    # [:mlhs_paren,
    #   [[:mlhs_paren, [:@ident, "x", [1, 12]]]]
    # ]
    _, args = node

    visit_mlhs_or_mlhs_paren(args)
  end

  def visit_mlhs_or_mlhs_paren(args)
    # Sometimes a paren comes, some times not, so act accordingly.
    has_paren = current_token_kind == :on_lparen
    doc = []
    if has_paren
      skip_token :on_lparen
      skip_space_or_newline
      doc << "("
    end

    # For some reason there's nested :mlhs_paren for
    # a single parentheses. It seems when there's
    # a nested array we need parens, otherwise we
    # just output whatever's inside `args`.
    if args.is_a?(Array) && args[0].is_a?(Array)
      doc << B.indent(visit_comma_separated_list_doc args, force_trailing_comma: in_multiple_assignment? && args.length == 1)
      skip_space_or_newline
    else
      doc << visit(args)
    end

    if has_paren
      # Ripper has a bug where parsing `|(w, *x, y), z|`,
      # the "y" isn't returned. In this case we just consume
      # all tokens until we find a `)`.
      while current_token_kind != :on_rparen
        doc << skip_token(current_token_kind)
      end

      skip_token :on_rparen
      doc << ")"
    end
    B.concat(doc)
  end

  def visit_mrhs_add_star(node)
    # [:mrhs_add_star, [], [:vcall, [:@ident, "x", [3, 8]]]]
    _, x, y = node
    doc = []
    if x.empty?
      skip_op "*"
      doc << "*#{visit(y)}"
    else
      doc << visit(x)
      # visit x
      doc << ","
      doc << B::LINE
      skip_params_comma if comma?
      skip_space
      skip_op "*"
      # visit y
      doc << "*#{visit(y)}"
    end
    B.group(B.concat(doc))
  end

  def visit_for(node)
    #[:for, var, collection, body]
    _, var, collection, body = node

    doc = ["for "]
    skip_keyword "for"
    skip_space

    doc << visit_comma_separated_list_doc(to_ary(var))
    skip_space
    if comma?
      check :on_comma

      next_token
      skip_space_or_newline
    end

    skip_space
    skip_keyword "in"
    doc << " in "
    skip_space
    doc << visit(collection)
    skip_space_or_newline
    skip_keyword "do" if current_token_value == "do"

    body_doc = visit_exps_doc(body, with_lines: true)
    parts = body_doc[:parts]
    if parts.last[:type] == :line_suffix_boundary && parts[-2][:type] == :line
      parts.pop
      parts.pop
    end
    doc << B.group(
      B.concat([B.if_break("", " do"), B.indent(B.concat([B::LINE, body_doc])), B::LINE, "end"]),
      should_break: body.length > 1
    )
    skip_space
    skip_keyword "end"
    B.concat(doc)
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

    skip_keyword(keyword)
    skip_space

    skip_token :on_lbrace
    skip_space
    doc = visit_exps_doc(body)
    skip_space
    skip_token :on_rbrace

    return B.group(
      B.concat([keyword, " {", B.indent(B.concat([B::LINE, doc])), B::LINE, "}"]),
      should_break: body.length > 1
    )
  end

  def visit_comma_separated_list_doc_no_group(nodes, include_trailing_comma: trailing_commas, force_trailing_comma: false)
    should_break = comment?
    # List of normal args and heredoc args
    doc = []
    # list_includes_heredoc = false
    nodes = to_ary(nodes)
    nodes.each_with_index do |exp, i|
      is_last = last?(i, nodes)
      # had_heredocs = !@heredocs.empty?
      written_comma = false
      needs_break = handle_space_or_newline_doc(doc, with_lines: false)
      should_break ||= needs_break
      doc << B::LINE_SUFFIX_BOUNDARY
      if block_given?
        r = yield exp
      else
        r = visit(exp)
      end

      doc << r
      if @last_was_heredoc
        doc << B::LITERAL_LINE
        @last_was_heredoc = false
      end

      skip_space
      if comma?
        check :on_comma
        next_token
      end

      unless written_comma
        if is_last && !force_trailing_comma
          doc << B.if_break(include_trailing_comma ? "," : "", "")
        else
          doc << ","
        end
      end

      needs_break = handle_space_or_newline_doc(
        doc,
        newline_limit: 0 # Only add comments on the current line.
      )
      should_break ||= needs_break
      doc << B::LINE unless is_last
    end
    [should_break, B.concat(doc)]
  end

  def visit_comma_separated_list_doc(nodes, include_trailing_comma: trailing_commas, force_trailing_comma: false)
    should_break, doc = visit_comma_separated_list_doc_no_group(nodes, include_trailing_comma: include_trailing_comma, force_trailing_comma: force_trailing_comma)
    B.group(doc, should_break: should_break)
  end

  def visit_mlhs_add_star(node)
    # [:mlhs_add_star, before, star, after]
    _, before, star, after = node

    doc = []
    if before && !before.empty?
      # Maybe a Ripper bug, but if there's something before a star
      # then a star shouldn't be here... but if it is... handle it
      # somehow...
      if current_token_kind == :on_op && current_token_value == "*"
        after = star
        star = before
      else
        doc << visit_comma_separated_list_doc(to_ary(before))
      end
    end

    skip_op "*"
    star_doc = "*"

    if star
      skip_space_or_newline
      star_doc = "*" + visit(star)
    end
    doc << star_doc

    if after && !after.empty?
      skip_comma_and_spaces
      doc << visit_comma_separated_list_doc(after)
    end
    B.join(", ", doc)
  end

  def visit_unary(node)
    # [:unary, :-@, [:vcall, [:@ident, "x", [1, 2]]]]
    _, op, exp = node
    doc = [skip_op_or_keyword]

    first_space = space?
    skip_space_or_newline
    if op == :not
      has_paren = current_token_kind == :on_lparen

      if has_paren && !first_space
        doc << "("
        next_token
        skip_space_or_newline
      end

      unless has_paren
        doc << " "
      end

      doc << visit(exp)

      if has_paren && !first_space
        skip_space_or_newline
        check :on_rparen
        doc << ")"
        next_token
      end
    else
      doc <<  visit(exp)
    end
    B.concat(doc)
  end

  def visit_binary(node)
    # [:binary, left, op, right]
    _, left, _, right = node

    doc = [visit(left)]

    skip_space_backslash
    skip_space

    doc << B::LINE
    doc << skip_op_or_keyword

    skip_space

    if handle_space_or_newline_doc(doc)
      doc << B::LINE_SUFFIX_BOUNDARY
    elsif doc.last != B::LINE
      doc << B::LINE
    end
    doc << visit(right)
    B.group(B.indent(B.concat(doc)))
  end

  def skip_op_or_keyword
    case current_token_kind
    when :on_op, :on_kw
      result = current_token_value
      next_token
    else
      bug "Expected op or kw, not #{current_token_kind}"
    end
    result
  end

  def visit_class(node)
    # [:class,
    #   name
    #   superclass
    #   [:bodystmt, body, nil, nil, nil]]
    _, name, superclass, body = node
    doc = ["class", " "]
    skip_keyword "class"
    skip_space_or_newline
    doc << visit(name)

    if superclass
      skip_space_or_newline
      doc << " "
      skip_op "<"
      doc << "<"
      skip_space_or_newline
      doc << " "
      doc << visit(superclass)
    end

    handle_space_or_newline_doc(doc, newline_limit: 0)
    skip_space_or_newline
    doc << visit_doc(body)
    # doc << B::LINE
    B.concat(doc)
  end

  def visit_module(node)
    # [:module,
    #   name
    #   [:bodystmt, body, nil, nil, nil]]
    _, name, body = node
    doc = ["module "]
    skip_keyword "module"
    handle_space_or_newline_doc(doc)
    skip_space
    doc << visit(name)

    doc << visit(body)
    B.concat(doc)
  end

  def visit_def(node)
    # [:def,
    #   [:@ident, "foo", [1, 6]],
    #   [:params, nil, nil, nil, nil, nil, nil, nil],
    #   [:bodystmt, [[:void_stmt]], nil, nil, nil]]
    _, name, params, body = node
    doc = [B::DOUBLE_SOFT_LINE, "def "]
    skip_keyword "def"
    skip_space

    doc << visit_def_from_name(name, params, body)
    B.concat(doc)
  end

  def visit_def_with_receiver(node)
    # [:defs,
    # [:vcall, [:@ident, "foo", [1, 5]]],
    # [:@period, ".", [1, 8]],
    # [:@ident, "bar", [1, 9]],
    # [:params, nil, nil, nil, nil, nil, nil, nil],
    # [:bodystmt, [[:void_stmt]], nil, nil, nil]]
    _, receiver, _period, name, params, body = node
    doc = ["def "]
    skip_keyword "def"
    skip_space
    doc << visit(receiver)
    skip_space_or_newline

    check :on_period
    doc << "."
    next_token
    skip_space_or_newline

    doc << visit_def_from_name(name, params, body)
    B.concat(doc)
  end

  def visit_def_from_name(name, params, body)
    doc = [visit(name)]

    params = params[1] if params[0] == :paren

    skip_space

    if current_token_kind == :on_lparen
      next_token
      skip_space
      skip_semicolons

      if empty_params?(params)
        skip_space_or_newline
        check :on_rparen
        next_token
        doc << "()"
      else
        doc << "("
        doc << visit_doc(params)

        skip_space_or_newline
        check :on_rparen
        doc << ")"
        next_token
      end
    elsif !empty_params?(params)
      if parens_in_def == :yes
        doc << "("
      else
        doc << " "
      end

      doc << B.group(visit_doc(params))
      doc << ")" if parens_in_def == :yes
      skip_space
    end

    doc << B.group(visit_doc(body), should_break: true)
    B.concat(doc)
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

    skip_token :on_lparen
    skip_space_or_newline

    doc = ["("]
    if exps
      doc << visit_exps_doc(to_ary(exps), with_lines: false)
    end

    skip_space_or_newline
    doc << ")"
    skip_token :on_rparen
    B.concat(doc)
  end

  def visit_params(node)
    # (def params)
    #
    # [:params, pre_rest_params, args_with_default, rest_param, post_rest_params, label_params, double_star_param, blockarg]
    _, pre_rest_params, args_with_default, rest_param, post_rest_params, label_params, double_star_param, blockarg = node

    needs_comma = false
    doc = []
    should_break = false
    if pre_rest_params
      should_break, pre_doc = visit_comma_separated_list_doc_no_group(pre_rest_params)
      doc << pre_doc
    end

    if args_with_default
      write_params_comma if needs_comma
      default_should_break, default_doc = visit_comma_separated_list_doc_no_group(args_with_default) do |arg, default|
        arg_doc = [visit(arg)]
        skip_space
        skip_op "="
        skip_space
        arg_doc << " = "
        arg_doc << visit(default)
        B.concat(arg_doc)
      end
      should_break ||= default_should_break
      if default_doc.is_a?(Hash)
        doc << default_doc
      else
        fail 'unexpected'
      end
    end

    if rest_param
      # check for trailing , |x, |
      if rest_param == 0
        # write_params_comma
      else
        # [:rest_param, [:@ident, "x", [1, 15]]]
        doc << visit_rest_param(rest_param)
      end
    end

    if post_rest_params
      skip_params_comma if comma?
      post_should_break, post_doc = visit_comma_separated_list_doc_no_group(post_rest_params)
      should_break ||= post_should_break
      doc = doc << post_doc
    end

    if label_params
      # [[label, value], ...]
      skip_params_comma if comma?
      label_should_break, label_doc = visit_comma_separated_list_doc_no_group(label_params) do |label, value|
        # [:@label, "b:", [1, 20]]
        label_doc = [label[1]]
        next_token
        skip_space_or_newline
        if value
          skip_space
          label_doc << " "
          label_doc << visit(value)
        end
        B.concat(label_doc)
      end
      should_break ||= label_should_break
      if label_doc.is_a?(Hash)
        doc << label_doc
      else
        fail 'unexpected'
      end
    end

    if double_star_param
      skip_params_comma if comma?
      skip_op "**"
      skip_space_or_newline

      # A nameless double star comes as an... Integer? :-S
      doc << "**#{visit(double_star_param)}" if double_star_param.is_a?(Array)
      doc << "**" unless double_star_param.is_a?(Array)
      skip_space_or_newline
    end

    if blockarg
      # [:blockarg, [:@ident, "block", [1, 16]]]
      skip_params_comma if comma?
      skip_space_or_newline
      skip_op "&"
      skip_space_or_newline
      doc << "&#{visit(blockarg[1])}"
    end
    B.group(B.join(B.concat([',', B::LINE]), doc), should_break: should_break)
  end

  def visit_rest_param(node)
    _, rest = node
    doc = []

    skip_params_comma if comma?
    skip_op "*"
    skip_space_or_newline
    doc << "*"
    doc << visit(rest) if rest
    B.concat(doc)
  end

  def visit_kwrest_param(node)
    # [:kwrest_param, name]

    _, name = node

    if name
      skip_space_or_newline
      visit name
    end
  end

  def skip_params_comma
    check :on_comma
    next_token
  end

  def flatten_array_elements(array)
    result = []
    array.each do |item|
      type, _ = item
      if type == :args_add_star
        _, pre, star, *post = item
        result.concat(pre)
        result << [:synthetic_star, star]
        result.concat(post)
      else
        result << item
      end
    end
    result
  end

  def visit_array(node)
    # [:array, elements]

    # Check if it's `%w(...)` or `%i(...)`
    case current_token_kind
    when :on_qwords_beg, :on_qsymbols_beg, :on_words_beg, :on_symbols_beg
      return visit_q_or_i_array(node)
    end

    _, elements = node

    doc = []
    check :on_lbracket
    next_token

    if elements
      pre_comments, doc, should_break = visit_literal_elements_doc(flatten_array_elements(to_ary(elements)))
      while doc.last.is_a?(Hash) && doc.last[:type] == :line
        doc.pop
      end

      doc = doc_group(
        B.concat([
          "[",
          B.indent(B.concat([B.concat(pre_comments), B::SOFT_LINE, *doc])),
          B::SOFT_LINE,
          "]",
        ]),
        should_break,
      )
    else
      skip_space_or_newline
      doc = "[]"
    end

    check :on_rbracket
    next_token
    doc
  end

  def visit_q_or_i_array(node)
    _, elements = node
    doc = []
    # For %W it seems elements appear inside other arrays
    # for some reason, so we flatten them
    if elements[0].is_a?(Array) && elements[0][0].is_a?(Array)
      elements = elements.flat_map { |x| x }
    end

    doc << current_token_value.strip

    # (pre 2.5.0) If there's a newline after `%w(`, write line and indent
    if current_token_value.include?("\n") && elements # "%w[\n"
      doc << B::SOFT_LINE
    end

    next_token

    # fix for 2.5.0 ripper change
    if current_token_kind == :on_words_sep && elements && !elements.empty?
      next_token
    end

    if elements && !elements.empty?

      elements.each_with_index do |elem, i|
        if elem[0] == :@tstring_content
          # elem is [:@tstring_content, string, [1, 5]
          doc << elem[1].strip
          next_token
        else
          doc << visit(elem)
        end

        if !last?(i, elements) && current_token_kind == :on_words_sep
          # On a newline, write line and indent
          next_token
          doc << B::LINE
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

    if last_token
      doc << last_token[2].strip
    else
      doc << current_token_value.strip
      next_token
    end
    B.concat([B.group(B.indent(B.concat([B::SOFT_LINE, B.concat(doc)]))), B::SOFT_LINE])
  end

  def visit_hash(node)
    # [:hash, elements]
    _, elements = node
    # token_column = current_token_column

    # closing_brace_token, _ = find_closing_brace_token
    # need_space = need_space_for_hash?(node, closing_brace_token)

    check :on_lbrace
    next_token

    if elements
      # [:assoclist_from_args, elements]
      pre_comments, doc, should_break = visit_literal_elements_doc(to_ary(elements[1]))
      while doc.last.is_a?(Hash) && doc.last[:type] == :line
        doc.pop
      end
      doc = doc_group(
        B.concat([
          "{",
          B.indent(B.concat([B.concat(pre_comments), B::SOFT_LINE, *doc])),
          B::SOFT_LINE,
          "}",
        ]),
        should_break
      )
    else
      skip_space_or_newline
      doc = "{}"
    end

    check :on_rbrace
    next_token
    doc
  end

  # Helper manipulate the inner_group_breaks stack and set the break for the
  # group correctly.
  def doc_group(contents, should_break)
    inner_group_broke = !!@inner_group_breaks.pop
    should_break ||= inner_group_broke
    result = B.group(contents, should_break: should_break)
    @inner_group_breaks.push(should_break)
    result
  end

  def visit_hash_key_value(node)
    # key => value
    #
    # [:assoc_new, key, value]
    _, key, value = node
    doc = []

    # If a symbol comes it means it's something like
    # `:foo => 1` or `:"foo" => 1` and a `=>`
    # always follows
    symbol = current_token_kind == :on_symbeg
    arrow = symbol || !(key[0] == :@label || key[0] == :dyna_symbol)

    doc << visit(key)
    skip_space_or_newline

    # Don't output `=>` for keys that are `label: value`
    # or `"label": value`
    if arrow
      next_token
      doc << " => "
      skip_space_or_newline
    else
      doc << ' '
    end
    doc << visit(value)
    B.concat(doc)
  end

  def visit_splat_inside_hash(node)
    # **exp
    #
    # [:assoc_splat, exp]
    skip_op "**"
    skip_space_or_newline
    B.concat(["**", visit(node[1])])
  end

  def visit_range(node, inclusive)
    # [:dot2, left, right]
    _, left, right = node
    doc = []
    doc << visit(left)
    skip_space_or_newline
    op = inclusive ? ".." : "..."
    skip_op(op)
    doc << op
    skip_space_or_newline
    doc << visit(right)
    B.concat(doc)
  end

  def visit_regexp_literal(node)
    # [:regexp_literal, pieces, [:@regexp_end, "/", [1, 1]]]
    _, pieces = node

    check :on_regexp_beg
    doc = [current_token_value]
    next_token

    doc << visit_exps_doc(pieces, with_lines: false)

    check :on_regexp_end
    doc << current_token_value
    next_token
    B.concat(doc)
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
    doc = [visit(name)]

    skip_space
    check :on_lbracket
    doc << "["
    next_token

    skip_space

    # Sometimes args comes with an array...
    if args && args[0].is_a?(Array)
      _pre_comments, args_doc, should_break = visit_literal_elements_doc(args)
      while args_doc.last.is_a?(Hash) && args_doc.last[:type] == :line
        args_doc.pop
      end
      doc << B.group(B.concat(args_doc), should_break: should_break)
    else
      skip_space_or_newline

      if args
        doc << visit(args)
      end
    end

    skip_space_or_newline

    check :on_rbracket
    doc << "]"
    next_token
    B.concat(doc)
  end

  def visit_sclass(node)
    # class << self
    #
    # [:sclass, target, body]
    _, target, body = node
    doc = [
      skip_keyword("class"),
      " ",
      "<<",
      " ",
    ]

    skip_space
    next_token
    skip_space
    doc << visit(target)
    doc << visit_doc(body)
    B.concat(doc)
  end

  def visit_setter(node)
    # foo.bar
    # (followed by `=`, though not included in this node)
    #
    # [:field, receiver, :".", name]
    _, receiver, _, name = node

    doc = []
    doc << visit(receiver)

    skip_space_or_newline

    doc << skip_call_dot

    skip_space_or_newline

    doc << visit(name)

    B.concat(doc)
  end

  def visit_control_keyword(node, keyword)
    _, exp = node

    doc = [skip_keyword(keyword)]

    if exp && !exp.empty?
      skip_space
      doc << " " unless node[1].first == :paren
      doc << visit_exps_doc(to_ary(node[1]), with_lines: false)
    end
    B.concat(doc)
  end

  def visit_lambda(node)
    # [:lambda, [:params, nil, nil, nil, nil, nil, nil, nil], [[:void_stmt]]]
    # [:lambda, [:params, nil, nil, nil, nil, nil, nil, nil], [[:@int, "1", [2, 2]], [:@int, "2", [3, 2]]]]
    # [:lambda, [:params, nil, nil, nil, nil, nil, nil, nil], [:bodystmt, [[:@int, "1", [2, 2]], [:@int, "2", [3, 2]]], nil, nil, nil]] (on 2.6.0)
    _, params, body = node

    body = body[1] if body[0] == :bodystmt
    check :on_tlambda
    doc = ["-> "]
    next_token

    skip_space

    unless empty_params?(params)
      doc << visit(params)
      skip_space
      doc << " "
    end

    brace = current_token_value == "{"

    if brace
      skip_token :on_tlambeg
    else
      skip_keyword "do"
    end
    body_doc = [B.if_break("do", "{")]

    body_doc << B.indent(B.concat([B::LINE, visit_exps_doc(body)]))

    if brace
      skip_token :on_rbrace
    else
      skip_keyword "end"
    end

    body_doc << B.concat([B::SOFT_LINE, B.if_break("end", "}")])
    doc << B.group(B.concat(body_doc), should_break: body.length > 1)
    B.concat(doc)
  end

  def visit_super(node)
    # [:super, args]
    _, args = node

    skip_keyword "super"
    doc = ["super"]

    if space?
      doc << " "
      skip_space
      doc << visit_command_args_doc(args)
    else
      doc << visit_call_at_paren(node, args)
    end
    B.concat(doc)
  end

  def visit_defined(node)
    # [:defined, exp]
    _, exp = node

    skip_keyword "defined?"
    has_space = space?
    doc = ["defined?"]

    if has_space
      skip_space
    else
      skip_space_or_newline
    end

    has_paren = current_token_kind == :on_lparen

    if has_paren && !has_space
      doc << "("
      next_token
      skip_space_or_newline
    end
    doc << " " unless has_paren
    doc << visit(exp)

    if has_paren && !has_space
      skip_space_or_newline
      check :on_rparen
      doc << ")"
      next_token
    end
    B.concat(doc)
  end

  def visit_alias(node)
    # [:alias, from, to]
    _, from, to = node
    doc = [
      skip_keyword("alias"),
      " "
    ]

    skip_space
    doc << visit(from)
    skip_space
    doc << " "
    doc << visit(to)
    B.concat(doc)
  end

  def visit_undef(node)
    # [:undef, exps]
    _, exps = node

    skip_keyword "undef"
    skip_space
    B.concat(["undef ", visit_comma_separated_list_doc(exps)])
  end

  def add_comments_on_line(element_doc, comments, newline_before_comment:)
    comments_present = false
    comments.each_with_index do |comment, i|
      if comment.is_a?(String)
        set_contains_comment
        comments_present = true
        if i == 0 && !element_doc.empty?
          if newline_before_comment
            element_doc << B.concat([
              element_doc.pop,
              B.line_suffix(B.concat([B::LINE, comment])),
            ])
          else
            element_doc << B.concat([element_doc.pop, B.line_suffix(B.concat([" ", comment]))])
          end
        else
          element_doc << B.line_suffix(B.concat([comment]))
        end
        element_doc << B::LINE_SUFFIX_BOUNDARY
      else
        element_doc << comment
      end
    end
    comments_present
  end

  # Handles literal elements where there are no comments or heredocs to worry
  # about.
  def visit_literal_elements_simple_doc(elements)
    doc = []

    skip_space_or_newline
    elements.each do |elem|
      doc_el = visit(elem)
      if doc_el.is_a?(Array)
        doc.concat(doc_el)
      else
        doc << doc_el
      end

      skip_space_or_newline
      next unless comma?
      next_token
      skip_space_or_newline
    end

    doc
  end

  def add_heredoc_to_doc(doc, current_doc, element_doc, comments, is_last: false)
    value, comment = check_heredocs_in_literal_elements_doc
    if value
      value = B.concat(value)
    end
    add_heredoc_to_doc_with_value(doc, current_doc, element_doc, comments, value, comment, is_last: is_last)
  end

  def add_heredoc_to_doc_with_value(doc, current_doc, element_doc, comments, value, comment, is_last: false)
    return [current_doc, false, element_doc] if value.nil?

    last = current_doc.pop
    unless last.nil?
      doc << B.join(
        B.concat([",", B::LINE_SUFFIX_BOUNDARY, B::LINE]),
        [*current_doc, B.concat([last, B.if_break(',', '')])]
      )
    end

    unless comments.empty?
      comment = element_doc.pop
    end

    comment_array = [B.line_suffix(" " + comment)] if comment
    comment_array ||= []

    doc_with_heredoc = []
    unless element_doc.empty?
      doc_with_heredoc.concat(element_doc)
      if trailing_commas || !is_last
        doc_with_heredoc << ","
      end
    end
    doc_with_heredoc.concat(
      [*comment_array, B::LINE_SUFFIX_BOUNDARY, value, B::SOFT_LINE]
    )
    doc << B.concat(doc_with_heredoc)
    return [[], true, []]
  end

  def visit_literal_elements_doc(elements)
    doc = []
    current_doc = []
    element_doc = []
    pre_comments = []
    has_heredocs = false

    has_comment = handle_space_or_newline_doc(doc)

    elements.each_with_index do |elem, i|
      @literal_elements_level = @node_level
      is_last = elements.length == i + 1

      current_doc.concat(element_doc)
      element_doc = []
      @last_was_heredoc = false if @last_was_heredoc
      doc_el = visit(elem)
      if doc_el.is_a?(Array)
        element_doc.concat(doc_el)
      else
        element_doc << doc_el
      end

      if @last_was_heredoc
        current_doc, heredoc_present, element_doc = add_heredoc_to_doc_with_value(
          doc, current_doc, element_doc, [], element_doc.pop, nil, is_last: is_last,
        )
      else
        current_doc, heredoc_present, element_doc = add_heredoc_to_doc(
          doc, current_doc, element_doc, [], is_last: is_last,
        )
      end
      has_heredocs ||= heredoc_present

      unless heredoc_present || !@heredocs.empty?
        if last?(i, elements)
          if trailing_commas
            element_doc << B.if_break(',', '')
          end
        else
          element_doc << B.concat([','])
        end
      end

      comments, _newline_before_comment = skip_space_or_newline
      has_comment = true if add_comments_on_line(element_doc, comments, newline_before_comment: false)

      unless comma?
        element_doc << B::LINE
        next
      end
      next_token_no_heredoc_check
      current_doc, heredoc_present, element_doc = add_heredoc_to_doc(
        doc, current_doc, element_doc, comments, is_last: is_last,
      )
      has_heredocs ||= heredoc_present
      comments, newline_before_comment = skip_space_or_newline

      has_comment = true if add_comments_on_line(element_doc, comments, newline_before_comment: newline_before_comment)
      element_doc << B::LINE
    end
    @literal_elements_level = nil
    current_doc.concat(element_doc)
    doc.concat(current_doc)
    [pre_comments, doc, has_comment || has_heredocs]
  end

  def check_heredocs_in_literal_elements_doc
    doc, comment = skip_space_heredoc
    return [doc, comment] unless (doc.nil? || doc.empty?) && comment.nil?
    if (newline? || comment?) && !@heredocs.empty?
      return flush_heredocs_doc
    end
    []
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

    doc = [keyword, " "]
    skip_keyword(keyword)
    skip_space
    doc << visit(node[1])
    skip_space
    skip_semicolons
    handle_space_or_newline_doc(doc, newline_limit: 0)

    doc << B.indent(B.concat([B::LINE, indent_body_doc(node[2])]))
    if (else_body = node[3])
      doc << B::LINE

      case else_body[0]
      when :else
        skip_keyword "else"
        doc << "else"
        handle_space_or_newline_doc(doc)
        doc << B.indent(B.concat([B::LINE, indent_body_doc(else_body[1])]))
      when :elsif
        doc << visit_if_or_unless(else_body, "elsif", check_end: false)
      else
        bug "expected else or elsif, not #{else_body[0]}"
      end
    end

    if check_end
      doc << B::LINE
      doc << "end"
      skip_keyword "end"
    end
    B.concat(doc)
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

    doc = [keyword, " "]
    skip_keyword keyword
    skip_space

    doc << visit(cond)
    handle_space_or_newline_doc(doc)

    doc << B.indent(B.concat([B::LINE, indent_body_doc(body, force_multiline: true)]))

    skip_keyword "end"
    doc << B::LINE
    doc << "end"
    B.concat(doc)
  end

  def visit_case(node)
    # [:case, cond, case_when]
    _, cond, case_when = node
    doc = ["case"]
    skip_keyword "case"
    handle_space_or_newline_doc(doc)

    if cond
      doc << " "
      skip_space
      doc << visit(cond)
    end
    doc << B::LINE

    skip_space_or_newline

    # write_indent
    doc << visit(case_when)

    # write_indent
    doc << "end"
    skip_keyword "end"
    B.concat(doc)
  end

  def visit_when(node)
    # [:when, conds, body, next_exp]
    _, conds, body, next_exp = node
    doc = ["when", " "]
    skip_keyword "when"
    skip_space
    # Align conditions on subsequent lines with the first condition.
    # This is done so that the subsequent conditions are distinctly conditions
    # rather than part of the body of the when statement.
    doc << B.align(5, visit_comma_separated_list_doc(conds, include_trailing_comma: false))
    skip_space

    then_keyword = keyword?("then")
    if then_keyword
      next_token
      skip_space
      handle_space_or_newline_doc(doc)
    end

    doc << B.indent(B.concat([B::LINE, visit_exps_doc(body)]))
    doc << B::LINE

    if next_exp
      if next_exp[0] == :else
        # [:else, body]
        next_doc = ["else"]
        skip_keyword "else"

        handle_space_or_newline_doc(next_doc)
        next_doc << B::LINE
        next_doc << visit_exps_doc(next_exp[1])
        doc << B.indent(B.concat(next_doc))
        doc << B::LINE
      else
        doc << visit(next_exp)
      end
    end
    B.concat(doc)
  end

  def skip_space
    first_space = space? ? current_token : nil
    next_token while space?
    first_space
  end

  def skip_space_heredoc
    result = nil
    while space?
      result = next_token
      return result unless result.reject(&:empty?).empty?
    end
    return result
  end

  def skip_ignored_space
    next_token while current_token_kind == :on_ignored_sp
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

  def skip_space_or_newline(newline_limit = Float::INFINITY)
    num_newlines = 0
    found_comment = false
    found_semicolon = false
    newline_before_comment = false
    last = nil
    second_last = nil
    comments = []
    loop do
      case current_token_kind
      when :on_nl, :on_ignored_nl, :on_semicolon
        break if num_newlines >= newline_limit
      end

      case current_token_kind
      when :on_sp
        next_token
      when :on_nl, :on_ignored_nl
        next_token
        second_last = last
        last = :newline
        num_newlines += 1
      when :on_semicolon
        next_token
        second_last = last
        # Pretend that we have found a newline as we treat semicolons as newlines.
        last = :newline
        num_newlines += 1
        found_semicolon = true
      when :on_comment
        if current_token_value.end_with?("\n")
          num_newlines += 1
        end
        if last == :newline && second_last == :newline
          comments << B::DOUBLE_SOFT_LINE
        elsif last == :newline
          comments << B::SOFT_LINE
        end
        comments << current_token_value.rstrip
        next_token
        found_comment = true

        if current_token_value.end_with?("\n")
          second_last = :comment
          last = :newline
        else
          second_last = last
          last = :comment
        end
        break if num_newlines >= newline_limit
      when :on_embdoc_beg
        if last == :newline && second_last == :newline
          comments << B::DOUBLE_SOFT_LINE
        elsif last == :newline
          comments << B::SOFT_LINE
        end
        comment = skip_embedded_comment
        comments << comment.rstrip
        if comment.end_with?("\n")
          second_last = :comment
          last = :newline
        else
          second_last = last
          last = :comment
        end
      else
        break
      end
    end
    if last == :newline && second_last == :newline
      comments << B::DOUBLE_SOFT_LINE
    elsif last == :newline
      comments << B::SOFT_LINE
    end
    [comments, newline_before_comment, found_semicolon, num_newlines]
  end

  def skip_semicolons
    while semicolon? || space?
      next_token
    end
  end

  def skip_token(kind)
    val = current_token_value
    check kind
    doc, _ = next_token
    if doc.empty?
      return val
    end
    B.concat([val] + doc)
  end

  def skip_keyword(value)
    check :on_kw
    if current_token_value != value
      bug "Expected keyword #{value}, not #{current_token_value}"
    end
    next_token
    value
  end

  def skip_op(value)
    check :on_op
    if current_token_value != value
      bug "Expected op #{value}, not #{current_token_value}"
    end
    next_token
  end

  def skip_embedded_comment
    result = ""

    while current_token_kind != :on_embdoc_end
      result += current_token_value
      next_token
    end

    result += current_token_value
    next_token
    result
  end

  # __END__
  def consume_end
    return "" unless current_token_kind == :on___end__

    line = current_token_line
    result = ""
    result += skip_token :on___end__

    lines = @code.lines[line..-1]
    lines.each do |l|
      result += l.chomp
      result += "\n"
    end
    result
  end

  def indent_body_doc(exps, force_multiline: false)
    doc = []

    has_semicolon = semicolon?

    if has_semicolon
      next_token
      skip_semicolons
    end

    # If an end follows there's nothing to do
    if keyword?("end")
      return B.concat(doc)
    end

    # A then keyword can appear after a newline after an `if`, `unless`, etc.
    # Since that's a super weird formatting for if, probably way too obsolete
    # by now, we just remove it.
    has_then = keyword?("then")
    if has_then
      next_token
    end

    has_do = keyword?("do")
    if has_do
      next_token
    end

    handle_space_or_newline_doc(doc)

    if keyword?("then")
      next_token
      skip_space_or_newline
    end

    # If the body is [[:void_stmt]] it's an empty body
    # so there's nothing to write
    if exps.size == 1 && exps[0][0] == :void_stmt
      handle_space_or_newline_doc(doc)
      return B.concat(doc)
    else
      return visit_exps_doc(exps, with_lines: force_multiline)
    end
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

  def next_token
    prev_token = self.current_token

    @tokens.pop

    if (newline? || comment?) && !@heredocs.empty?
      return flush_heredocs_doc
    end

    was_newline = prev_token && (prev_token[1] == :on_nl || prev_token[1] == :on_ignored_nl)
    if was_newline
      @last_was_newline = true
    else
      @last_was_newline = false
    end
    [[]]
  end

  def next_token_no_heredoc_check
    @tokens.pop
  end

  def last?(index, array)
    index == array.size - 1
  end

  def to_ary(node)
    node[0].is_a?(Symbol) ? [node] : node
  end

  def broken_ripper_version?
    version, teeny = RUBY_VERSION[0..2], RUBY_VERSION[4..4].to_i
    (version == "2.3" && teeny < 5) ||
      (version == "2.4" && teeny < 2)
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
    # get line of node, it is only used in visit_hash right now,
    # so handling the following node types is enough.
    case node.first
    when :hash, :string_literal, :symbol_literal, :symbol, :vcall, :string_content, :assoc_splat, :var_ref
      node_line(node[1], beginning: beginning)
    when :assoc_new
      if beginning
        node_line(node[1], beginning: beginning)
      else
        if node.last == [:string_literal, [:string_content]]
          # there's no line number for [:string_literal, [:string_content]]
          node_line(node[1], beginning: beginning)
        else
          node_line(node.last, beginning: beginning)
        end
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
