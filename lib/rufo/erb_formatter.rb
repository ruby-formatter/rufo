# frozen_string_literal: true
require "erb"

class Rufo::ErbFormatter
  def self.format(code, **options)
    new(code, **options).format
  end

  attr_reader :result

  def initialize(code, **options)
    compiler = ERB::Compiler.new("<>")
    @options = options
    @scanner = compiler.make_scanner(code)
    @code_mode = false
    @current_lineno = 0
  end

  def format
    out = []
    process_erb do |(type, content)|
      if type == :code
        out << " #{process_code(content)} "
      else
        out << content
      end

      lines = out.last.count("\n")
      if lines > 0
        self.current_lineno = current_lineno + lines
      end
    end
    @result = out.join("")
  end

  private

  attr_reader :scanner, :code_mode
  attr_accessor :current_lineno

  def process_erb
    code = []
    scanner.scan do |token|
      if token.is_a?(String) && token.end_with?("%>")
        disable_code_mode
        yield [:code, code.join("")]
        yield [:text, token]
        code = []
      elsif code_mode
        code << token
      elsif token == :cr
        yield [:text, "\n"]
      else
        yield [:text, token]
      end

      enable_code_mode if token.is_a?(String) && token.start_with?("<%")
    end
  end

  def process_code(code_str)
    sexps = Ripper.sexp(code_str)
    if sexps.nil?
      prefix, suffix = determine_code_wrappers(code_str)
    end
    result = format_code("#{prefix} " + code_str + " #{suffix}")
    unless suffix.nil?
      result = result.chomp(suffix)
    end
    unless prefix.nil?
      result = result.sub(prefix, "")
    end
    result.strip
  end

  def determine_code_wrappers(code_str)
    return nil, "\nend" if Ripper.sexp("#{code_str}\nend")
    return nil, "}" if Ripper.sexp("#{code_str} }")
    return "{", nil if Ripper.sexp("{ #{code_str}")
    return "begin", nil if Ripper.sexp("begin #{code_str}")
    return "begin\n", "\nend" if Ripper.sexp("begin\n#{code_str}\nend")
    raise_syntax_error!(code_str)
  end

  def raise_syntax_error!(code_str)
    format_code(code_str)
  rescue Rufo::SyntaxError => e
    raise Rufo::SyntaxError.new(e.message, current_lineno + e.lineno)
  end

  def format_code(str)
    Rufo::Formatter.format(str).chomp
  end

  def enable_code_mode
    @code_mode = true
  end

  def disable_code_mode
    @code_mode = false
  end
end
