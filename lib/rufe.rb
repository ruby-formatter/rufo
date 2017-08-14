# frozen_string_literal: true

require "ripper"
require "awesome_print"

module Rufe; end

class Rufe::Formatter
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
    
    @indent_size = 2
    @line_length = options.fetch(:line_length, 80)

    @indent = 0
    @column = 0
    @last_was_newline = true
    @output = "".dup

    # the current group
    @group = nil
  end

  def format
    visit @sexp
    consume_end
  end

  def result
    @output
  end

  private

  def visit(node)
    unless node.is_a?(Array)
      bug "Expected array node, but found: #{node} at #{current_token}"
    end

    case node.first
    when :program
      # Topmost node
      #
      # [:program, exps]
      visit_exps node[1] #, with_indent: true
    when :string_literal
      visit_string_literal(node)
    when :string_content
      # [:string_content, exp]
      visit_exps node[1..-1], with_lines: false
    when :@tstring_content
      # [:@tstring_content, "hello", [1, 1]]
      consume_token :on_tstring_content
    when :@const
      # [:@const, "FOO", [1, 0]]
      consume_token :on_const
    when :@gvar
      # [:@gvar, "$abc", [1, 0]]
      write node[1]
      next_token
    when :@op
      # [:@op, "*", [1, 1]]
      write node[1]
      next_token
    when :const_ref
      # [:const_ref, [:@const, "Foo", [1, 8]]]
      visit node[1]
    when :string_embexpr
      visit_string_interpolation(node)
    when :vcall
      # [:vcall, exp]
      visit node[1]
    when :@ident
      consume_token :on_ident
    when :assign
      visit_assign(node)
    when :opassign
      visit_op_assign(node)
    when :massign
      visit_multiple_assign(node)
    when :var_field
      # [:var_field, exp]
      visit node[1]
    when :def
      visit_def(node)
    when :paren
      visit_paren(node)
    when :bodystmt
      visit_bodystmt(node)
    when :if
      visit_if(node)
    when :unless
      visit_unless(node)
    when :case
      visit_case(node)
    when :when
      visit_when(node)
    when :var_ref
      # [:var_ref, exp]
      visit node[1]
    when :params
      visit_params(node)
    when :void_stmt
      # [:void_stmt]
      skip_space_or_newline
    when :hash
      visit_hash(node)
    when :array
      visit_array(node)
    when :assoc_new
      visit_hash_key_value(node)
    when :assoc_splat
      visit_splat_inside_hash(node)
    when :dyna_symbol
      visit_quoted_symbol_literal(node)
    when :binary
      visit_binary(node)
    when :unary
      visit_unary(node)
    when :@label
      # [:@label, "foo:", [1, 3]]
      write node[1]
      check :on_label
      next_token
    when :class
      visit_class(node)
    when :symbol_literal
      # [:symbol_literal, [:symbol, [:@ident, "foo", [1, 1]]]]
      #
      # A symbol literal not necessarily begins with `:`.
      # For example, an `alias foo bar` will treat `foo`
      # a as symbol_literal but without a `:symbol` child.
      visit node[1]
    when :symbol
      # [:symbol, [:@ident, "foo", [1, 1]]]
      consume_token :on_symbeg
      visit_exps node[1..-1], with_lines: false
    when :@int
      # Integer literal
      #
      # [:@int, "123", [1, 0]]
      consume_token :on_int
    when :begin
      visit_begin(node)
    when :mrhs_new_from_args
      visit_mrhs_new_from_args(node)
    when :args_add_star
      visit_args_add_star(node)
    when :BEGIN
      visit_BEGIN(node)
    when :END
      visit_END(node)
    when :alias, :var_alias
      visit_alias(node)
    else
      bug "Unhandled node: #{node.first} at #{current_token}"
    end
  end

  # Visit an array of expressions
  #
  # - with_lines:  consume whole line for each expression
  def visit_exps(exps, with_lines: true)
    skip_space_or_newline

    exps.each_with_index do |exp, i|
      visit exp

      is_last = last?(i, exps)

      if with_lines
        exp_needs_two_lines = needs_two_lines?(exp)

        consume_end_of_line

        # Make sure to put two lines before defs, class and others
        if !is_last && exp_needs_two_lines && needs_two_lines?(exps[i + 1])
          write_hardline
        end
      end
    end
  end

  # Consume and print an end of line, handling semicolons and comments
  #
  # - at_prefix: are we at a point before an expression? (if so, we don't need a space before the first comment)
  # - want_multiline: do we want multiple lines to appear, or at most one?
  def consume_end_of_line(at_prefix: false, want_multiline: true)
    multiple_lines = false                   # Did we pass through more than one newline?
    last = last_is_newline? ? :newline : nil # last token kind found
    found_newline = last == :newline         # Did we find any newline during this method?

    loop do
      debug("consume_end_of_line: start #{current_token_kind} #{current_token_value}")
      case current_token_kind
      when :on_nl, :on_ignored_nl, :on_semicolon
        if last == :newline
          multiple_lines = true
        else
          write_hardline
        end

        next_token
        last = :newline
        found_newline = true
      when :on_sp
        # ignore spaces
        next_token
      else
        debug("consume_end_of_line: end #{current_token_kind}")
        break
      end
    end

    # Output a newline if we didn't do so yet:
    # either we didn't find a newline and we are at the end of a line (and we didn't just pass a semicolon),
    # or we just passed multiple lines (but printed only one)
    if (!found_newline && !at_prefix) || (multiple_lines && want_multiline)
      write_hardline
    end
  end

  # Skip spaces and newlines
  def skip_space_or_newline
    loop do
      debug("skip_space_or_newline: start #{current_token_kind} #{current_token_value}")
      case current_token_kind
      when :on_nl, :on_ignored_nl, :on_sp, :on_semicolon
        next_token
      else
        debug("skip_space_or_newline: end #{current_token_kind} #{current_token_value}")
        break
      end
    end
  end

  def visit_begin(node)
    # [:begin, [:bodystmt, body, rescue_body, else_body, ensure_body]]
    _, body_statement = node
    _, _body, rescue_body, _else_body, ensure_body = body_statement

    group do
      indent_level = if rescue_body || ensure_body
                       @column
                     else
                       @indent
                     end

      indent(indent_level) do
        consume_keyword "begin"
        write_if_break(HARDLINE, "; ")
        visit body_statement
      end
    end
  end

  def visit_string_literal(node)
    # [:string_literal, [:string_content, exps]]
    consume_token :on_tstring_beg
    
    inner = node[1..-1]
    
    visit_exps(inner, with_lines: false)

    consume_token :on_tstring_end
  end

  def visit_string_interpolation(node)
    # [:string_embexpr, exps]
    consume_token :on_embexpr_beg
    skip_space_or_newline
    visit_exps(node[1], with_lines: false)
    skip_space_or_newline
    consume_token :on_embexpr_end
  end

  def visit_assign_value(value)
    skip_space_or_newline

    if %i(on_int on_tstring_beg).include?(current_token_kind)
      write_line
      indent do
        visit(value)
      end
    else
      write " "
      visit value
    end
  end

  def visit_assign(node)
    # [:assign, target, value]
    _, target, value = node

    group do
      visit(target)

      consume_space
      consume_op "="

      visit_assign_value(value)
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

      _, body, rescue_body, else_body, ensure_body = body
      rescue_body || else_body || ensure_body
    else
      false
    end
  end

  def visit_def(node)
    # [:def,
    #   [:@ident, "foo", [1, 6]],
    #   [:params, nil, nil, nil, nil, nil, nil, nil],
    #   [:bodystmt, [[:void_stmt]], nil, nil, nil]]
    _, name, params, body = node

    params = params[1] if params[0] == :paren

    group do
      consume_keyword "def"
      consume_space

      visit name

      skip_space

      if current_token_kind == :on_lparen
        next_token
        skip_space
      end

      if !empty_params?(params)
        group do
          write "("
          write_softline

          indent do
            visit params
          end

          write_softline
          write ")"
          next_token
        end
      end

      write_if_break(HARDLINE, "; ")

      visit body
    end
  end

  def visit_op_assign(node)
    # target += value
    #
    # [:opassign, target, op, value]
    _, target, op, value = node

    group do
      visit target
      consume_space

      # [:@op, "+=", [1, 2]],
      check :on_op

      write op[1]
      next_token

      visit_assign_value value
    end
  end

  def visit_multiple_assign(node)
    # [:massign, lefts, right]
    _, lefts, right = node

    group do
      visit_comma_separated_list lefts

      first_space = skip_space

      # A trailing comma can come after the left hand side
      if comma?
        consume_token :on_comma
        first_space = skip_space
      end

      write " "
      consume_op "="
      visit_assign_value right
    end
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

    group do
      consume_token :on_lparen
      skip_space_or_newline
      write_softline

      if exps
        indent do
          exps = to_ary(exps)
          visit_exps exps, with_lines: !exps.one?
        end
      end

      skip_space_or_newline
      consume_token :on_rparen
    end
  end

  def visit_bodystmt(node)
    # [:bodystmt, body, rescue_body, else_body, ensure_body]
    _, body, rescue_body, else_body, ensure_body = node

    if body == [[:void_stmt]]
      skip_space_or_newline
    else
      write_breaking
      indent_body(body)
    end

    # [:rescue, type, name, body, more_rescue]
    while rescue_body
      _, type, name, body, more_rescue = rescue_body

      consume_keyword "rescue"

      if type
        skip_space
        write(" ")
        visit_rescue_types(type)
      end

      if name
        consume_space
        consume_op "=>"
        consume_space
        visit(name)
      end

      consume_end_of_line
      indent_body body

      rescue_body = more_rescue
    end

    if ensure_body
      # [:ensure, body]
      consume_keyword "ensure"
      write_hardline
      indent_body ensure_body[1]
    end

    consume_keyword "end"
  end

  def visit_rescue_types(node)
    group do
      visit_exps to_ary(node), with_lines: false
    end
  end

  def visit_if(node)
    visit_if_or_unless("if", node)
  end

  def visit_unless(node)
    visit_if_or_unless("unless", node)
  end

  def visit_if_or_unless(keyword, node)
    # if cond
    #   then_body
    # else
    #   else_body
    # end
    #
    # [:if, cond, then, else]
    _, condition, body, else_body = node

    indent(@column) do
      consume_keyword(keyword)
      consume_space
      visit condition
      skip_space
      write_hardline

      indent_body body

      consume_keyword "end"
    end
  end

  def visit_case(node)
    # [:case, cond, case_when]
    _, cond, case_when = node

    indent(@column) do
      consume_keyword "case"

      consume_end_of_line

      visit case_when

      consume_keyword "end"
    end
  end

  def visit_when(node)
    # [:when, conds, body, next_exp]
    _, conds, body, next_exp = node

    consume_keyword "when"
    consume_space

    visit_comma_separated_list conds
    consume_end_of_line

    indent_body body
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

    # If the whole block fits into a single line, format
    # in a single line
    group do
      consume_token :on_lbrace

      indent do
        skip_space_or_newline
        write_hardline
        visit_exps body, with_lines: true
        skip_space_or_newline
      end

      consume_token :on_rbrace
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

  def visit_params(node)
    # [:params, pre_rest_params, args_with_default, rest_param, post_rest_params, label_params, double_star_param, blockarg]
    _, pre_rest_params, args_with_default, rest_param, post_rest_params, label_params, double_star_param, blockarg = node

    visit_comma_separated_list pre_rest_params
  end

  def visit_comma_separated_list(nodes)
    nodes = to_ary(nodes)
    nodes.each_with_index do |exp, i|
      visit exp

      next if last?(i, nodes)

      skip_space
      check :on_comma
      write ","
      next_token
      skip_space
      write_line
    end
  end

  def visit_hash(node)
    # [:hash, elements]
    _, elements = node

    # token_column = current_token_column

    check :on_lbrace
    group do
      write "{"
      next_token

      if elements
        indent do
          # [:assoclist_from_args, elements]
          visit_literal_elements(elements[1], inside_hash: true)
        end
      else
        skip_space_or_newline
      end

      write_softline
      check :on_rbrace
      write "}"
    end
    next_token
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
    group do
      write "["
      next_token

      if elements
        indent do
          visit_literal_elements to_ary(elements), inside_array: true
        end
      else
        skip_space_or_newline
      end

      check :on_rbracket
      write "]"
    end

    next_token
  end

  def visit_class(node)
    # [:class,
    #   name
    #   superclass
    #   [:bodystmt, body, nil, nil, nil]]
    _, name, superclass, body = node

    group do
      consume_keyword "class"
      consume_space
      visit name
      write_if_break(HARDLINE, "; ")
      visit body
    end
  end

  def visit_literal_elements(elements, inside_hash: false, inside_array: false)
    skip_space_or_newline
    write_line if inside_hash
    write_softline if inside_array

    elements.each_with_index do |elem, i|
      visit elem
      is_last = last?(i, elements)
      skip_space_or_newline

      if comma? && !is_last
        consume_token :on_comma
        write_line
      elsif comma?
        next_token
      elsif is_last
        if inside_hash
          write_if_break(",", " ")
        elsif inside_array
          write_if_break(",", "")
          write_softline
        end
      end
      skip_space_or_newline
    end

    skip_space
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

  def visit_binary(node)
    # [:binary, left, op, right]
    _, left, op, right = node

    group do
      visit left

      consume_space

      consume_op_or_keyword op

      skip_space_or_newline
      write_line
      visit right
    end
  end

  def visit_unary(node)
    # [:unary, :-@, [:vcall, [:@ident, "x", [1, 2]]]]
    _, op, exp = node

    consume_op_or_keyword op

    if current_token_kind == :on_lparen
      consume_token :on_lparen
      skip_space_or_newline
      visit exp
      skip_space_or_newline
      consume_token :on_rparen
    else
      consume_space
      visit exp
    end
  end

  def to_ary(node)
    node[0].is_a?(Symbol) ? [node] : node
  end

  def indent_body(exps)
    indent do
      visit_exps exps #, with_lines: false
    end
  end

  def check(kind)
    if current_token_kind != kind
      bug "Expected token #{kind}, not #{current_token_kind}\n\n#{@tokens.last(2).reverse.ai}"
    end
  end

  def consume_token(kind)
    check kind
    consume_token_value(current_token_value)
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

  def consume_keyword(value)
    check :on_kw
    if current_token_value != value
      bug "Expected keyword #{value}, not #{current_token_value}"
    end
    write value
    next_token
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

  def consume_space
    skip_space_or_newline
    write(" ")
  end

  def skip_space
    first_space = space? ? current_token : nil
    next_token while space?
    first_space
  end

  def skip_semicolons
    while semicolon? || space?
      next_token
    end
  end

  def space?
    current_token_kind == :on_sp
  end

  def semicolon?
    current_token_kind == :on_semicolon
  end

  def comma?
    current_token_kind == :on_comma
  end

  def last_is_newline?
    if @group
      @group.buffer_string[-1] == "\n"
    else
      @output[-1] == "\n"
    end
  end

  def last?(i, array)
    i == array.size - 1
  end

  def keyword?(kw)
    current_token_kind == :on_kw && current_token_value == kw
  end

  def needs_two_lines?(exp)
    kind = exp[0]

    case kind
    when :def
      true
    else
      false
    end
  end

  def next_token
    @tokens.pop
  end

  def consume_token_value(value)
    write value
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

  def append(value)
    if @group
      fail "no newlines" if value == "\n"
      @group.buffer << value
    else
      @output << value
    end
  end

  def write(value)
    debug "write: #{value.inspect}"
    append(value)
    value = Group.string_value(value)

    if value == "\n"
      @last_was_newline = true
      @column = 0
    else
      @column += value.length
    end

    debug "checking for line length: #{@column.ai}"
    if @column > @line_length
      write_breaking
    end
  end

  def write_params_comma
    skip_space
    consume_token :on_comma
    next_token
    skip_space
    write_line
  end

  def write_breaking
    @group.breaking = true if @group
  end

  def write_line
    fail "Can only write LINE inside a group" unless @group

    write LINE
  end

  def write_softline
    fail "Can only write SOFTLINE inside a group" unless @group

    write SOFTLINE
  end

  def write_hardline
    if @group
      write HARDLINE
      write_breaking
    else
      write("\n")
    end
  end

  def write_if_break(break_value, no_break_value)
    fail "Can only write GroupIfBreak inside a group" unless @group

    write(GroupIfBreak.new(break_value, no_break_value))
  end

  def write_group(group)
    if @group
      @group.buffer.concat([group])
    else
      debug "current_column: #{@column.ai}"
      debug "write_group #{group.ai raw: true, index: false}"
      group.buffer_string.each_char { |c| write(c) }
    end
  end

  def set_indent(value)
    if @group
      append(GroupIndent.new(value))
    end

    @indent = value
  end

  def indent(value = nil)
    if value
      old_indent = @indent
      set_indent(value)
      yield
      set_indent(old_indent)
    else
      set_indent(@indent + @indent_size)
      yield
      set_indent(@indent - @indent_size)
    end
  end

  def dedent(value = nil)
    if value
      old_indent = @indent
      set_indent(value)
      yield
      set_indent(old_indent)
    else
      set_indent(@indent - @indent_size)
      yield
      set_indent(@indent + @indent_size)
    end
  end

  def group
    old_group = @group
    @group = Group.new(indent: @indent)
    debug "OPEN GROUP #{@group.object_id}"
    yield
    group_to_write = @group
    @group = old_group
    debug "WRITE GROUP #{group_to_write.object_id}"
    write_group group_to_write
  end

  def consume_end
    return unless current_token_kind == :on___end__

    line = current_token_line

    write_hardline if @output[-2..-1] != "\n\n"
    consume_token :on___end__

    lines = @code.lines[line..-1]
    lines.each do |line|
      write line.chomp
      write_hardline
    end
  end

  GroupIndent = Struct.new(:indent)
  GroupIfBreak = Struct.new(:break_value, :no_break_value)

  LINE = :line
  SOFTLINE = :softline
  HARDLINE = :hardline

  class Group
    def self.string_value(token, breaking: false)
      case token
      when LINE
        breaking ? "\n" : " "
      when SOFTLINE
        breaking ? "\n" : ""
      when HARDLINE
        "\n"
      when GroupIfBreak
        breaking ? token.break_value : token.no_break_value
      when String
        token
      when Group
        token.buffer_string
      else
        fail "Unknown token #{token.ai}"
      end
    end

    def initialize(indent:, breaking: false)
      @breaking = breaking
      @indent = indent
      @buffer = []
    end

    attr_accessor :buffer, :breaking

    def buffer_string
      indent = @indent
      last_was_newline = false
      output = "".dup
      tokens = buffer.dup

      while token = tokens.shift
        if token.is_a?(GroupIndent)
          indent = token.indent
          next
        end

        string_value = self.class.string_value(token, breaking: breaking)
        current_is_newline = string_value == "\n"

        if last_was_newline && !current_is_newline
          output << (" " * indent)
        end

        case token
        when String
          output << string_value
          last_was_newline = false
        when LINE
          output << string_value
          last_was_newline = breaking
        when SOFTLINE
          output << string_value
          last_was_newline = breaking
        when HARDLINE
          output << string_value
          last_was_newline = true
        when GroupIfBreak
          tokens.unshift(string_value)
        when Group
          output << string_value
          last_was_newline = false
        else
          fail "Unknown token #{token.ai}"
        end
      end

      output
    end
  end

  DEBUG = false

  def debug(msg)
    if DEBUG
      puts msg
    end
  end

  def bug(msg)
    raise Rufo::Bug.new("#{msg} at #{current_token}")
  end
end
