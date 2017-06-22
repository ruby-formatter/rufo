require "rufo/version"

module Rufo
  class Bug < Exception; end

  class SyntaxError < Exception; end

  def self.format(code, **options)
    Formatter.format(code, **options)
  end
end

require_relative "rufo/command"
require_relative "rufo/formatter"
