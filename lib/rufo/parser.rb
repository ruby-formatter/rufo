# frozen_string_literal: true

require "ripper"

class Rufo::Parser < Ripper
  def compile_error(msg)
    raise ::Rufo::SyntaxError.new(msg, lineno)
  end

  def on_parse_error(msg)
    raise ::Rufo::SyntaxError.new(msg, lineno)
  end

  def self.sexp_unparsable_code(code)
    code_type = detect_unparsable_code_type(code)

    case code_type
    when :yield
      extract_original_code_sexp(
        "def __rufo_dummy; #{code}; end",
        ->(exp) { exp => [:def, *, [:bodystmt, exps, *]]; exps }
      )
    when :next, :break, :redo
      extract_original_code_sexp(
        "loop do; #{code}; end",
        ->(exp) { exp => [:method_add_block, *, [:do_block, nil, [:bodystmt, [[:void_stmt], *exps], *]]]; exps }
      )
    when :retry
      extract_original_code_sexp(
        "begin; rescue; #{code}; end",
        ->(exp) { exp => [:begin, [:bodystmt, Array, [:rescue, nil, nil, exps, *], *]]; exps }
      )
    end
  end

  def self.detect_unparsable_code_type(code)
    tokens = self.lex(code)
    token = tokens.find { |_, kind| kind != :on_sp && kind != :on_ignored_nl }

    case token
    in [_, :on_kw, "yield" | "next" | "break" | "retry" | "redo" => kw, _]
      kw.to_sym
    else
      nil
    end
  end

  def self.extract_original_code_sexp(decorated_code, extractor)
    sexp = self.sexp(decorated_code)
    return nil unless sexp

    # [:program, [exp]]
    exp = sexp[1][0]
    code_exps = extractor.call(exp)
    [:program, code_exps]
  end
end
