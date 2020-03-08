# frozen_string_literal: true

module Rufo
  class Bug < StandardError; end
  class UnknownSyntaxError < StandardError; end

  class SyntaxError < StandardError
    attr_reader :lineno

    def initialize(message, lineno)
      super(message)
      @lineno = lineno
    end
  end

  def self.format(code, **options)
    Formatter.format(code, **options)
  end
end

require_relative "rufo/command"
require_relative "rufo/logger"
require_relative "rufo/dot_file"
require_relative "rufo/settings"
require_relative "rufo/parser"
require_relative "rufo/formatter"
require_relative "rufo/erb_formatter"
require_relative "rufo/version"
require_relative "rufo/file_list"
require_relative "rufo/file_finder"
