# frozen_string_literal: true

require "prism"

class Rufo::PrismFormatter
  include Rufo::Settings

  def self.format(code, **options)
    formatter = new(code, **options)
    formatter.format
    formatter.result
  end

  def initialize(code, **options)
    @code = code
    @parse_result = Prism.parse(code)
    unless @parse_result.errors.empty?
      error = @parse_result.errors.first
      raise Rufo::SyntaxError.new(error.message, error.location.start_line)
    end

    init_settings(options)
  end

  def format
    @output = @code.dup

    @output.chomp! if @output.end_with?("\n\n")
    @output.lstrip!
    @output = "\n" if @output.empty?
  end

  def result
    @output
  end
end
