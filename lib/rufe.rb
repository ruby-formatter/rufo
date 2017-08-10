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
    else
      bug "Unhandled node: #{node.first} at #{current_token}"
    end
  end

  def visit_exps(exps)
    consume_end_of_line(at_prefix: true)

    exps.each_with_index do |exp, i|
      visit exp
    end
  end

  # Consume and print an end of line, handling semicolons and comments
  #
  # - at_prefix: are we at a point before an expression? (if so, we don't need a space before the first comment)
  def consume_end_of_line(at_prefix: true)
    loop do
      case current_token_kind
      when :on_ignored_nl
        # ignore for now
        next_token
      else
        break
      end
    end
  end

  def visit_string_literal(node)
    # [:string_literal, [:string_content, exps]]
    consume_token :on_tstring_beg
    
    inner = node[1..-1]
    
    visit_exps(inner)

    consume_token :on_tstring_end
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
  end

  def bug(msg)
    raise Rufo::Bug.new("#{msg} at #{current_token}")
  end
end
