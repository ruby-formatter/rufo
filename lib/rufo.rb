# frozen_string_literal: true

module Rufo
  class Bug < StandardError; end

  class SyntaxError < StandardError; end

  def self.format(code, **options)
    Formatter.format(code, **options)
  end
end

require_relative "rufo/backport"
require_relative "rufo/command"
require_relative "rufo/dot_file"
require_relative "rufo/settings"
require_relative "rufo/doc_builder"
require_relative "rufo/doc_printer"
require_relative "rufo/formatter"
require_relative "rufo/version"
