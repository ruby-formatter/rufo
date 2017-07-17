# frozen_string_literal: true

require "optparse"

class Rufo::Command
  CODE_OK = 0
  CODE_ERROR = 1
  CODE_CHANGE = 3

  def self.run(argv)
    want_check, filename_for_dot_rufo = parse_options(argv)
    new(want_check, filename_for_dot_rufo).run(argv)
  end

  def initialize(want_check, filename_for_dot_rufo)
    @want_check = want_check
    @filename_for_dot_rufo = filename_for_dot_rufo
    @dot_file = Rufo::DotFile.new
  end

  def run(argv)
    status_code = if argv.empty?
                    format_stdin
                  else
                    format_args argv
                  end

    exit status_code
  end

  def format_stdin
    code = STDIN.read

    result = format(code, @filename_for_dot_rufo || Dir.getwd)

    print(result) if !@want_check

    code == result ? CODE_OK : CODE_CHANGE
  rescue Rufo::SyntaxError
    STDERR.puts "Error: the given text is not a valid ruby program (it has syntax errors)"
    CODE_ERROR
  rescue => ex
    STDERR.puts "You've found a bug!"
    STDERR.puts "Please report it to https://github.com/ruby-formatter/rufo/issues with code that triggers it"
    STDERR.puts
    raise ex
  end

  def format_args(args)
    files = []

    args.each do |arg|
      if Dir.exist?(arg)
        files.concat Dir[File.join(arg, '**', '*.rb')].select(&File.method(:file?))
      elsif File.exist?(arg)
        files << arg
      else
        STDERR.puts "Error: file or directory not found: #{arg}"
      end
    end

    return CODE_ERROR if files.empty?

    changed = false
    syntax_error = false

    files.each do |file|
      result = format_file(file)

      changed |= result == CODE_CHANGE
      syntax_error |= result == CODE_ERROR
    end

    case
    when syntax_error then CODE_ERROR
    when changed      then CODE_CHANGE
    else                   CODE_OK
    end
  end

  def format_file(filename)
    code = File.read(filename)

    begin
      result = format(code, File.dirname(filename))
    rescue Rufo::SyntaxError
      # We ignore syntax errors as these might be template files
      # with .rb extension
      STDERR.puts "Error: #{filename} has syntax errors"
      return CODE_ERROR
    end

    if code.force_encoding(result.encoding) != result
      if @want_check
        STDERR.puts "Formatting #{filename} produced changes"
      else
        File.write(filename, result)
        puts "Format: #{filename}"
      end

      return CODE_CHANGE
    end
  rescue Rufo::SyntaxError
    STDERR.puts "Error: the given text in #{filename} is not a valid ruby program (it has syntax errors)"
    CODE_ERROR
  rescue => ex
    STDERR.puts "You've found a bug!"
    STDERR.puts "It happened while trying to format the file #{filename}"
    STDERR.puts "Please report it to https://github.com/ruby-formatter/rufo/issues with code that triggers it"
    STDERR.puts
    raise ex
  end

  def format(code, dir)
    formatter = Rufo::Formatter.new(code)

    dot_rufo = @dot_file.find_in(dir)
    if dot_rufo
      begin
        formatter.instance_eval(dot_rufo)
      rescue => ex
        STDERR.puts "Error evaluating #{dot_rufo}"
        raise ex
      end
    end

    formatter.format
    formatter.result
  end

  def self.parse_options(argv)
    want_check = false
    filename_for_dot_rufo = nil

    OptionParser.new do |opts|
      opts.version = Rufo::VERSION
      opts.banner = "Usage: rufo files or dirs [options]"

      opts.on("-c", "--check", "Only check formating changes") do
        want_check = true
      end

      opts.on("--filename=value", "Filename to use to lookup .rufo (useful for STDIN formatting)") do |value|
        filename_for_dot_rufo = value
      end

      opts.on("-h", "--help", "Show this help") do
        puts opts
        exit
      end
    end.parse!(argv)

    [want_check, filename_for_dot_rufo]
  end
end
