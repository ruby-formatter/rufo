require "optionparser"

module Rufo::Command
  def self.run(argv)
    want_check = parse_options(argv)

    if argv.empty?
      format_stdin want_check
    else
      format_args argv, want_check
    end
  end

  def self.format_stdin(want_check)
    code   = STDIN.read
    result = format(code, Dir.getwd)

    if want_check
      exit 1 if result != code
    else
      print result
    end
  rescue Rufo::SyntaxError
    STDERR.puts "Error: the given text is not a valid ruby program (it has syntax errors)"
    exit 1
  rescue Rufo::Bug => ex
    STDERR.puts "You've found a bug!"
    STDERR.puts "Please report it to https://github.com/asterite/rufo/issues with code that triggers it"
    STDERR.puts
    raise ex
  end

  def self.format_args(args, want_check)
    files = []

    args.each do |arg|
      if Dir.exist?(arg)
        files.concat Dir["#{arg}/**/*.rb"].select(&File.method(:file?))
      elsif File.exist?(arg)
        files << arg
      else
        STDERR.puts "Error: file or directory not found: #{arg}"
      end
    end

    changed = false

    files.each do |file|
      success   = format_file file, want_check
      changed ||= success
    end

    exit 1 if changed
  end

  def self.format_file(filename, want_check)
    code = File.read(filename)

    begin
      result = format(code, File.dirname(filename))
    rescue Rufo::SyntaxError
      # We ignore syntax errors as these might be template files
      # with .rb extension
      STDERR.puts "Error: #{filename} has syntax errors"
      return true
    end

    if code != result
      if want_check
        STDERR.puts "Error: formatting #{filename} produced changes"
      else
        File.write(filename, result)
        puts "Format: #{filename}"
      end

      return true
    end

    false
  rescue Rufo::SyntaxError
    STDERR.puts "Error: the given text in #{filename} is not a valid ruby program (it has syntax errors)"
    exit 1
  rescue Rufo::Bug => ex
    STDERR.puts "You've found a bug!"
    STDERR.puts "It happened while trying to format the file #{filename}"
    STDERR.puts "Please report it to https://github.com/asterite/rufo/issues with code that triggers it"
    STDERR.puts
    raise ex
  end

  def self.format(code, dir)
    formatter = Rufo::Formatter.new(code)

    dot_rufo = find_dot_rufo(dir)
    if dot_rufo
      begin
        formatter.instance_eval(File.read(dot_rufo))
      rescue => ex
        STDERR.puts "Error evaluating #{dot_rufo}"
        raise ex
      end
    end

    formatter.format
    formatter.result
  end

  def self.find_dot_rufo(dir)
    dir  = File.expand_path(dir)
    file = File.join(dir, ".rufo")
    if File.exist?(file)
      return file
    end

    parent_dir = File.dirname(dir)
    return if parent_dir == dir

    find_dot_rufo(parent_dir)
  end

  def self.parse_options(argv)
    want_check = false

    OptionParser.new do |opts|
      opts.banner = "Usage: rufo files or dirs [options]"

      opts.on("-c", "--check", "Only check formating changes") do
        want_check = true
      end

      opts.on("-h", "--help", "Show this help") do
        puts opts
        exit
      end
    end.parse!(argv)

    want_check
  end
end
