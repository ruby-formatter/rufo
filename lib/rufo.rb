require "rufo/version"

module Rufo
  def self.format(code)
    Formatter.format(code)
  end
end

require_relative "rufo/formatter"
