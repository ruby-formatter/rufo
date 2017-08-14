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
require_relative "rufo/new_formatter"
require_relative "rufo/formatter"
require_relative "rufo/formatter/settings"
require_relative "rufo/version"
