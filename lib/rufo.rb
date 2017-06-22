require "rufo/version"

module Rufo
  class Bug < Exception; end
  class SyntaxError < Exception; end

  def self.format(code)
    Formatter.format(code)
  end
end

require_relative "rufo/command"
require_relative "rufo/formatter"
