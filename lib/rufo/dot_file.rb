# frozen_string_literal: true

class Rufo::DotFile
  def initialize
    @cache = {}
  end

  def get_config_in(dir)
    dot_rufo = find_in(dir)
    if dot_rufo
      return parse(dot_rufo)
    end
  end

  def find_in(dir)
    @cache.fetch(dir) do
      @cache[dir] = internal_find_in(dir)
    end
  end

  def parse(file_contents)
    file_contents.lines
                 .map { |s| s.strip.split(/\s+/, 2) }
                 .each_with_object({}) do |(name, value), acc|
      value ||= ""
      if value.start_with?(":")
        value = value[1..-1].to_sym
      elsif value == "true"
        value = true
      elsif value == "false"
        value = false
      elsif value.start_with?("[")
        value = value[1..-2].split(",")
      else
        $stderr.puts "Unknown config value=#{value.inspect} for #{name.inspect}"
        next
      end
      acc[name.to_sym] = value
    end
  end

  def internal_find_in(dir)
    dir = File.expand_path(dir)
    file = File.join(dir, ".rufo")
    if File.exist?(file)
      return File.read(file)
    end

    parent_dir = File.dirname(dir)
    return if parent_dir == dir

    find_in(parent_dir)
  end
end
