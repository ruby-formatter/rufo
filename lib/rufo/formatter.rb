require "ripper"

class Rufo::Formatter
  def self.format(code)
    formatter = new(code)
    formatter.format
    formatter.result
  end

  def initialize(code)
    @code = code
    @tokens = Ripper.lex(code).reverse!
    @sexp = Ripper.sexp(code)
    @output = ""
  end

  def format
    visit @sexp
    write_line
  end

  def visit(node)
    case node.first
    when :program
      # [:program, exps]
      visit_exps node[1]
    when :void_stmt
      # [:void_stmt]
      check :on_eof
    when :@int
      # [:@int, "123", [1, 0]]
      consume_token :on_int
    when :string_literal
      # [:string_literal, [:string_content, exps]]
      consume_token :on_tstring_beg
      visit_exps(node[1][1..-1])
      consume_token :on_tstring_end
    when :@tstring_content
      # [:@tstring_content, "hello ", [1, 1]]
      consume_token :on_tstring_content
    when :string_embexpr
      # [:string_embexpr, exps]
      consume_token :on_embexpr_beg
      skip_space
      visit_exps node[1]
      consume_token :on_embexpr_end
    when :symbol_literal
      # [:symbol_literal, [:symbol, [:@ident, "foo", [1, 1]]]]
      consume_token :on_symbeg
      visit_exps node[1][1..-1]
    when :dyna_symbol
      # [:dyna_symbol, exps]
      consume_token :on_symbeg
      visit_exps node[1]
      consume_token :on_tstring_end
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
    when :assign
      # [:assign, target, value]
      visit node[1]
      consume_space
      consume_op "="
      consume_space
      visit node[2]
    else
      raise "Unhandled node: #{node.first}"
    end
  end

  def visit_exps(exps)
    exps.each_with_index do |exp, i|
      visit exp
      skip_space

      case current_token_kind
      when :on_semicolon
        next_token
        skip_space
        case current_token_kind
        when :on_ignored_nl
          consume_lines
        when :on_eof
          # Nothing
        else
          write ";"
          write " " unless last?(i, exps)
        end
      when :on_nl
        consume_lines
      end

      skip_space_or_newline
    end
  end

  def visit_string(node)
  end

  def consume_lines
    written_lines = 0

    while true
      case current_token_kind
      when :on_nl, :on_ignored_nl
        write_line if written_lines < 2
        written_lines += 1
        next_token
      when :on_sp, :on_semicolon
        next_token
      else
        break
      end
    end
  end

  def consume_space
    skip_space
    write " "
  end

  def skip_space
    while current_token_kind == :on_sp
      next_token
    end
  end

  def skip_space_or_newline
    while true
      case current_token_kind
      when :on_sp, :on_nl, :on_semicolon
        next_token
        next
      else
        break
      end
    end
  end

  def write(value)
    @output << value
  end

  def consume_token(kind)
    check kind
    write current_token_value
    next_token
  end

  def consume_op(value)
    check :on_op
    if current_token_value != value
      raise "Expected op #{value}, not #{current_token_value}"
    end
    write current_token_value
    next_token
  end

  def write_line
    @output << "\n"
  end

  def check(kind)
    if current_token_kind != kind
      raise "Expected token #{kind}, not #{current_token_kind}"
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

  def next_token
    @tokens.pop
  end

  def last?(i, array)
    i == array.size - 1
  end

  def result
    @output
  end
end