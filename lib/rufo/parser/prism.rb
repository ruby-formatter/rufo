# frozen_string_literal: true

require "prism"

class Rufo::Parser::Prism < ::Prism::Translation::Ripper
  def compile_error(msg)
    raise ::Rufo::SyntaxError.new(msg, lineno)
  end

  def on_parse_error(msg)
    raise ::Rufo::SyntaxError.new(msg, lineno)
  end
end
