module Rufo
  class Bug < Exception; end

  class SyntaxError < Exception; end

  def self.format(code, **options)
    Formatter.format(code, **options)
  end
end

require_relative "rufo/backport"
require_relative "rufo/command"
require_relative "rufo/dot_file"
require_relative "rufo/formatter"
require_relative "rufo/version"
