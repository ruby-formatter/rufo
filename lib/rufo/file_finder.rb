class Rufo::FileFinder
  include Enumerable

  def initialize(files_or_dirs)
    @files_or_dirs = files_or_dirs
  end

  def each
    files_or_dirs.each do |file_or_dir|
      if Dir.exist?(file_or_dir)
        rb_files = Dir[File.join(file_or_dir, "**", "*.rb")].select(&File.method(:file?))
        rb_files.each { |file| yield [true, file] }
      else
        yield [File.exist?(file_or_dir), file_or_dir]
      end
    end
  end

  private

  attr_reader :files_or_dirs
end
