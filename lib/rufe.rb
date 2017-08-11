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
    
    @indent = 0
    @indent_size = 2
    @line = 0
    @column = 0
    @last_was_newline = true
    @output = "".dup
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
      visit_exps node[1..-1] #, with_lines: false
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
    else
      bug "Unhandled node: #{node.first} at #{current_token}"
    end
  end

  # Visit an array of expressions
  #
  # - with_lines:  consume whole line for each expression
  def visit_exps(exps, with_lines: true, with_indent: false)
    consume_end_of_line(at_prefix: true)

    exps.each_with_index do |exp, i|
      write_indent if with_indent

      visit exp

      if with_lines
        consume_end_of_line
      end
    end
  end

  # Consume and print an end of line, handling semicolons and comments
  #
  # - at_prefix: are we at a point before an expression? (if so, we don't need a space before the first comment)
  def consume_end_of_line(at_prefix: true)
    debug("consume_end_of_line: start #{current_token_kind}")
    loop do
      case current_token_kind
      when :on_nl
        write_newline
        next_token
      when :on_ignored_nl
        # respect for now
        write_newline
        next_token
      when :on_sp
        # ignore spaces
        next_token
      when :on_semicolon
        # just do a newline for now
        write_newline
        next_token
      else
        debug("consume_end_of_line: end #{current_token_kind}")
        break
      end
    end
  end

  # Skip spaces and newlines
  def skip_space_or_newline
    debug("skip_space_or_newline: start #{current_token_kind}")
    loop do
      case current_token_kind
      when :on_nl, :on_ignored_nl, :on_sp
        next_token
      else
        debug("skip_space_or_newline: end #{current_token_kind}")
        break
      end
    end
  end

  def visit_string_literal(node)
    # [:string_literal, [:string_content, exps]]
    consume_token :on_tstring_beg
    
    inner = node[1..-1]
    
    visit_exps(inner, with_lines: true)

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

    visit(target)

    skip_space_or_newline

    write " "
    consume_op "="
    write " "

    visit(value)
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

  def visit_def_from_name(name, params, body)
    visit name

    skip_space

    if !empty_params?(params)
    end

    visit body
  end

  def empty_params?(node)
    _, a, b, c, d, e, f, g = node
    !a && !b && !c && !d && !e && !f && !g
  end

  def visit_bodystmt(node)
    # [:bodystmt, body, rescue_body, else_body, ensure_body]
    _, body, rescue_body, else_body, ensure_body = node

    indent_body(body)

    consume_keyword "end"
  end

  def indent_body(exps)
    first_space = skip_space

    indent do
      visit_exps exps, with_indent: true
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

  # TODO: I don't know what this does
  def push_hash(node)
    old_hash = @current_hash
    @current_hash = node
    yield
    @current_hash = old_hash
  end

  def check(kind)
    if current_token_kind != kind
      bug "Expected token #{kind}, not #{current_token_kind}"
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

  def keyword?(kw)
    current_token_kind == :on_kw && current_token_value == kw
  end

  def next_token
    @tokens.pop
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

  def write(value)
    @output << value
    @column += value.length
  end

  def write_newline
    @output << "\n"
    @last_was_newline = true
    @column = 0
    @line += 1
  end

  def write_indent(indent = @indent)
    write(" " * indent)
    @column += indent
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
