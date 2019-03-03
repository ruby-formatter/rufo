module Rufo
  class Logger
    LEVELS = {
      silent: 0,
      error: 1,
      warn: 2,
      log: 3,
      debug: 4,
    }

    def initialize(level)
      @level = LEVELS.fetch(level)
    end

    def debug(*args)
      $stdout.puts(*args) if should_output?(:debug)
    end

    def log(*args)
      $stdout.puts(*args) if should_output?(:log)
    end

    def warn(*args)
      $stderr.puts(*args) if should_output?(:warn)
    end

    def error(*args)
      $stderr.puts(*args) if should_output?(:error)
    end

    private

    attr_reader :level

    def should_output?(level_to_check)
      LEVELS.fetch(level_to_check) <= level
    end
  end
end
