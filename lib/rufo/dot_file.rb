# frozen_string_literal: true

class Rufo::DotFile
  def initialize
    @cache = {}
  end

  def find_in(dir)
    @cache.fetch(dir) do
      @cache[dir] = internal_find_in(dir)
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
