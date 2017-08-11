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
    @line_length = 80

    @indent = 0
    @column = 0
    @last_was_newline = true
    @output = "".dup

    # the current group
    @group = nil
  end

  def format
    visit @sexp
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
    when :string_embexpr
      visit_string_interpolation(node)
    when :vcall
      # [:vcall, exp]
      visit node[1]
    when :@ident
      consume_token :on_ident
    when :assign
      visit_assign(node)
    when :var_field
      # [:var_field, exp]
      visit node[1]
    when :def
      visit_def(node)
    when :bodystmt
      visit_bodystmt(node)
    when :var_ref
      # [:var_ref, exp]
      visit node[1]
    when :params
      visit_params(node)
    when :void_stmt
      # [:void_stmt]
      skip_space_or_newline
    else
      bug "Unhandled node: #{node.first} at #{current_token}"
    end
  end

  # Visit an array of expressions
  #
  # - with_lines:  consume whole line for each expression
  def visit_exps(exps, with_lines: true)
    skip_space_or_newline
    # consume_end_of_line(at_prefix: true, want_multiline: false)

    exps.each_with_index do |exp, i|
      visit exp

      is_last = last?(i, exps)

      if with_lines
        exp_needs_two_lines = needs_two_lines?(exp)

        if @group
          skip_space_or_newline
          write_softline
        else
          consume_end_of_line
        end

        # Make sure to put two lines before defs, class and others
        if !is_last && (exp_needs_two_lines || needs_two_lines?(exps[i + 1]))
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
      when :on_nl, :on_ignored_nl
        if last == :newline
          multiple_lines = true
        else
          # @group ? write_softline : write_hardline
          write_hardline
        end

        next_token
        last = :newline
        found_newline = true
      when :on_sp
        # ignore spaces
        next_token
      when :on_semicolon
        # just do a newline for now
        write_hardline
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

  def visit_assign(node)
    # [:assign, target, value]
    _, target, value = node

    group do
      visit(target)

      skip_space_or_newline

      write " "
      consume_op "="
      write_line

      indent do
        visit(value)
      end
    end
  end

  def visit_def(node)
    # [:def,
    #   [:@ident, "foo", [1, 6]],
    #   [:params, nil, nil, nil, nil, nil, nil, nil],
    #   [:bodystmt, [[:void_stmt]], nil, nil, nil]]
    _, name, params, body = node

    group do
      consume_keyword "def"
      consume_space

      visit name

      skip_space

      if !empty_params?(params)
        group do
          write "("
          write_softline

          visit params

          write_softline
          write ")"
          next_token
        end
      end

      write_if_break(HARDLINE, "; ")

      visit body
    end
  end

  def empty_params?(node)
    _, a, b, c, d, e, f, g = node
    !a && !b && !c && !d && !e && !f && !g
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

    consume_keyword "end"
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
      bug "Expected token #{kind}, not #{current_token_kind}\n\n#{@tokens.last(4).reverse.ai}"
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

  def consume_space
    skip_space_or_newline
    write(" ")
  end

  def skip_space
    first_space = space? ? current_token : nil
    next_token while space?
    first_space
  end

  def space?
    current_token_kind == :on_sp
  end

  def semicolon?
    current_token_kind == :on_semicolon
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

  def append(value)
    if @group
      fail "no newlines" if value == "\n"
      @group.buffer << value
    else
      @output << value
    end
  end

  def write(value)
    append(value)
    value = Group.string_value(value)

    if value == "\n"
      @last_was_newline = true
      @column = 0
    else
      @column += value.length
    end

    if @column > @line_length
      write_breaking
    end
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
      debug "write_group #{group.ai}"
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

  def group
    old_group = @group
    @group = Group.new(indent: @indent)
    yield
    group_to_write = @group
    @group = old_group
    write_group group_to_write
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

  DEBUG = true

  def debug(msg)
    if DEBUG
      puts msg
    end
  end

  def bug(msg)
    raise Rufo::Bug.new("#{msg} at #{current_token}")
  end
end
