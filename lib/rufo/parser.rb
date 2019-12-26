# frozen_string_literal: true

require "ripper"

class Rufo::Parser < Ripper
  def compile_error(msg)
    raise ::Rufo::SyntaxError.new(msg, lineno)
  end

  def on_parse_error(msg)
    raise ::Rufo::SyntaxError.new(msg, lineno)
  end
end
