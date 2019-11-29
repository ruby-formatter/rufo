# frozen_string_literal: true

module Rufo
  class Bug < StandardError; end

  class SyntaxError < StandardError
    attr_reader :msg, :lineno

    def initialize(msg, lineno)
      @msg = msg
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
require_relative "rufo/formatter"
require_relative "rufo/version"
require_relative "rufo/file_finder"
