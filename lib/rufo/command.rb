module Rufo::Command
  def self.run
    if ARGV.empty?
      format_stdin
    else
      format_file ARGV[0]
    end
  rescue Rufo::Bug => ex
    STDERR.puts "You've found a bug! Please report it to https://github.com/asterite/rufo/issues with code that triggers it"
    STDERR.puts
    raise ex
  rescue Rufo::SyntaxError
    STDERR.puts "Error: the given text is not a valid ruby program (it has syntax errors)" 
  end

  def self.format_stdin
    code = STDIN.read
    result = format(code, Dir.current)
    print result
  end

  def self.format_file(filename)
    code = File.read(filename)
    result = format(code, File.dirname(filename))
    File.write(filename, result)
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
    dir = File.expand_path(dir)
    file = File.join(dir, ".rufo")
    if File.exist?(file)
      return file
    end

    parent_dir = File.dirname(dir)
    return if parent_dir == dir

    find_dot_rufo(parent_dir)
  end
end
