module Rufo::Command
  def self.run
    if ARGV.empty?
      format_stdin
    else
      format_file ARGV[0]
    end
  end

  def self.format_stdin
    code = STDIN.read
    result = Rufo.format(code)
    print result
  end

  def self.format_file(filename)
    code = File.read(filename)
    result = Rufo.format(code)
    File.write(filename, result)
  end
end
