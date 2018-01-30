# frozen_string_literal: true

require "optparse"

class Rufo::Command
  CODE_OK = 0
  CODE_ERROR = 1
  CODE_CHANGE = 3

  def self.run(argv)
    want_check, exit_code, filename_for_dot_rufo = parse_options(argv)
    new(want_check, exit_code, filename_for_dot_rufo).run(argv)
  end

  def initialize(want_check, exit_code, filename_for_dot_rufo)
    @want_check = want_check
    @exit_code = exit_code
    @filename_for_dot_rufo = filename_for_dot_rufo
    @dot_file = Rufo::DotFile.new
    @squiggly_warning_files = []
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
        files.concat Dir[File.join(arg, "**", "*.rb")].select(&File.method(:file?))
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

    STDERR.puts squiggly_heredoc_warning unless @squiggly_warning_files.empty?

    case
    when syntax_error then CODE_ERROR
    when changed      then CODE_CHANGE
    else                   CODE_OK
    end
  end

  def squiggly_heredoc_warning
    <<-EOF
Rufo Warning!
  File#{squiggly_pluralize} #{squiggly_warning_files} #{squiggly_pluralize(:has)} not been formatted due to a problem with Ruby version #{RUBY_VERSION}
  Please update to Ruby #{backported_version} to fix your formatting!
  See https://github.com/ruby-formatter/rufo/wiki/Squiggly-Heredocs for information.
    EOF
  end

  def squiggly_pluralize(x = :s)
    idx = x == :s ? 0 : 1
    (@squiggly_warning_files.length > 1 ? ["s", "have"] : ["", "has"])[idx]
  end

  def squiggly_warning_files
    @squiggly_warning_files.join(", ")
  end

  def backported_version
    return "2.3.5" if RUBY_VERSION[0..2] == "2.3"
    "2.4.2"
  end

  def format_file(filename)
    code = File.read(filename)

    begin
      result = format(code, @filename_for_dot_rufo || File.dirname(filename))
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
        unless @squiggly_warning
          File.write(filename, result)
          puts "Format: #{filename}"
        else
          @squiggly_warning_files << filename
        end
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
    @squiggly_warning = false
    formatter = Rufo::Formatter.new(code)

    options = @dot_file.get_config_in(dir)
    unless options.nil?
      formatter.init_settings(options)
    end
    formatter.format
    result = formatter.result
    @squiggly_warning = true if formatter.squiggly_flag
    result
  end

  def self.parse_options(argv)
    exit_code, want_check = true, false
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

      opts.on("-x", "--simple-exit", "Return 1 in the case of failure, else 0") do
        exit_code = false
      end

      opts.on("-h", "--help", "Show this help") do
        puts opts
        exit
      end
    end.parse!(argv)

    [want_check, exit_code, filename_for_dot_rufo]
  end
end
