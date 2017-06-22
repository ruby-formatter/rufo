module Rufo::Command
  def self.run
    if ARGV.empty?
      format_stdin
    else
      format_args ARGV
    end
  rescue Rufo::SyntaxError
    STDERR.puts "Error: the given text is not a valid ruby program (it has syntax errors)"
  end

  def self.format_stdin
    code   = STDIN.read
    result = format(code, Dir.current)
    print result
  rescue Rufo::Bug => ex
    STDERR.puts "You've found a bug!"
    STDERR.puts "Please report it to https://github.com/asterite/rufo/issues with code that triggers it"
    STDERR.puts
  end

  def self.format_args(args)
    files = []

    args.each do |arg|
      if Dir.exist?(arg)
        files.concat Dir["#{arg}/**/*.rb"]
      elsif File.exist?(arg)
        files << arg
      else
        STDERR.puts "Error: file or directory not found: #{arg}"
      end
    end

    files.each do |file|
      format_file file
    end
  end

  def self.format_file(filename)
    code   = File.read(filename)
    result = format(code, File.dirname(filename))

    if code != result
      File.write(filename, result)
      puts "Format: #{filename}"
    end
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
end
