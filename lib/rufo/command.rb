# frozen_string_literal: true

require "optparse"

class Rufo::Command
  CODE_OK = 0
  CODE_ERROR = 1
  CODE_CHANGE = 3

  def self.run(argv)
    want_check, exit_code, filename_for_dot_rufo, loglevel = parse_options(argv)
    new(want_check, exit_code, filename_for_dot_rufo, loglevel).run(argv)
  end

  def initialize(want_check, exit_code, filename_for_dot_rufo, loglevel)
    @want_check = want_check
    @exit_code = exit_code
    @filename_for_dot_rufo = filename_for_dot_rufo
    @dot_file = Rufo::DotFile.new
    @logger = Rufo::Logger.new(loglevel)
  end

  def exit_code(status_code)
    if @exit_code
      status_code
    else
      case status_code
      when CODE_OK, CODE_CHANGE
        0
      else
        1
      end
    end
  end

  def run(argv)
    status_code = if argv.empty?
        format_stdin
      else
        format_args argv
      end
    exit exit_code(status_code)
  end

  def format_stdin
    code = STDIN.read

    erb = @filename_for_dot_rufo && @filename_for_dot_rufo.end_with?(".erb")
    result = format(code, @filename_for_dot_rufo || Dir.getwd, erb: erb)

    print(result) if !@want_check

    code == result ? CODE_OK : CODE_CHANGE
  rescue Rufo::SyntaxError => e
    logger.error("STDIN is invalid code. Error on line:#{e.lineno} #{e.message}")
    CODE_ERROR
  rescue Rufo::UnknownSyntaxError
    logger.error("STDIN is invalid code. Try running the code for a better error.")
    CODE_ERROR
  rescue => e
    logger.error("You've found a bug!")
    logger.error("Please report it to https://github.com/ruby-formatter/rufo/issues with code that triggers it\n")
    raise e
  end

  def format_args(args)
    top_level_dot_file = @filename_for_dot_rufo || Dir.getwd
    options = @dot_file.get_config_in(top_level_dot_file) || {}
    file_finder = Rufo::FileFinder.new(
      args, includes: options[:includes], excludes: options[:excludes],
    )
    files = file_finder.to_a

    changed = false
    syntax_error = false
    files_exist = false

    files.each do |(exists, file)|
      if exists
        files_exist = true
      else
        logger.warn("Error: file or directory not found: #{file}")
        next
      end
      result = format_file(file)

      changed |= result == CODE_CHANGE
      syntax_error |= result == CODE_ERROR
    end

    return CODE_ERROR unless files_exist

    case
    when syntax_error then CODE_ERROR
    when changed      then CODE_CHANGE
    else                   CODE_OK
    end
  end

  def format_file(filename)
    logger.debug("Formatting: #{filename}")
    code = File.read(filename, encoding: "UTF-8")

    begin
      location = @filename_for_dot_rufo || File.dirname(filename)
      erb = filename.end_with?(".erb")
      result = format(code, location, erb: erb)
    rescue Rufo::SyntaxError => e
      # We ignore syntax errors as these might be template files
      # with .rb extension
      logger.warn("#{filename}:#{e.lineno} #{e.message}")
      return CODE_ERROR
    end

    if code.force_encoding(result.encoding) != result
      if @want_check
        logger.warn("Formatting #{filename} produced changes")
      else
        File.write(filename, result)
        logger.log("Format: #{filename}")
      end

      return CODE_CHANGE
    end
  rescue Rufo::SyntaxError => e
    logger.error("#{filename}:#{e.lineno} #{e.message}")
    CODE_ERROR
  rescue Rufo::UnknownSyntaxError
    logger.error("#{filename} is invalid code. Try running the code for a better error.")
    CODE_ERROR
  rescue => e
    logger.error("You've found a bug!")
    logger.error("It happened while trying to format the file #{filename}")
    logger.error("Please report it to https://github.com/ruby-formatter/rufo/issues with code that triggers it\n")
    raise e
  end

  def format(code, dir, erb: false)
    options = @dot_file.get_config_in(dir) || {}
    if erb
      formatter = Rufo::ErbFormatter.new(code, **options)
    else
      formatter = Rufo::Formatter.new(code, **options)
    end

    formatter.format
    result = formatter.result
    result
  end

  def self.parse_options(argv)
    exit_code, want_check = true, false
    filename_for_dot_rufo = nil
    loglevel = :log

    OptionParser.new do |opts|
      opts.version = Rufo::VERSION
      opts.banner = "Usage: rufo files or dirs [options]"

      opts.on("-c", "--check", "Only check formating changes") do
        want_check = true
      end

      opts.on("--filename=value", "Filename to use to lookup .rufo (useful for STDIN formatting)") do |value|
        filename_for_dot_rufo = value
      end

      opts.on("-x", "--simple-exit", "Return 1 in the case of failure, else 0") do
        exit_code = false
      end

      opts.on(Rufo::Logger::LEVELS, "--loglevel[=LEVEL]", "Change the level of logging for the CLI. Options are: error, warn, log (default), debug, silent") do |value|
        loglevel = value.to_sym
      end

      opts.on("-h", "--help", "Show this help") do
        puts opts
        exit
      end
    end.parse!(argv)

    [want_check, exit_code, filename_for_dot_rufo, loglevel]
  end

  private

  attr_reader :logger
end
