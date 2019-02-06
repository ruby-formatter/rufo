class Rufo::FileFinder
  include Enumerable

  def initialize(files_or_dirs)
    @files_or_dirs = files_or_dirs
  end

  def each(&block)
    files_or_dirs.each do |file_or_dir|
      if Dir.exist?(file_or_dir)
        rb_files = Dir[File.join(file_or_dir, "**", "*.rb")].select(&File.method(:file?))
        rb_files.each(&block)
      elsif File.exist?(file_or_dir)
        yield file_or_dir
      else
        not_found << file_or_dir
      end
    end
  end

  def not_found
    @not_found ||= []
  end

  private

  attr_reader :files_or_dirs
end
