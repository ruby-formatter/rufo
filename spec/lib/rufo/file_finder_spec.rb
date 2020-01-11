RSpec.describe Rufo::FileFinder do
  subject { described_class.new([file_or_dir], includes: includes, excludes: excludes) }
  let(:includes) { [] }
  let(:excludes) { [] }

  context "the directory contains .rb files" do
    let(:file_or_dir) { finder_fixture_path("only_ruby") }

    it "returns all the .rb files in a directory" do
      expect(subject.to_a).to eql(abs_paths([[true, "a.rb"]]))
    end
  end

  context "the directory does not exist" do
    let(:file_or_dir) { finder_fixture_path("does_not_exist") }

    it "returns paths with exists flag of false" do
      expect(subject.to_a).to eql(abs_paths([[false, "does_not_exist"]], finder_fixture_path))
    end
  end

  context "the argument is a file" do
    let(:file_or_dir) { finder_fixture_path("only_ruby", "a.rb") }

    it "returns file provided" do
      expect(subject.to_a).to eql(abs_paths([[true, "only_ruby/a.rb"]], finder_fixture_path))
    end
  end

  context "the argument is a file that does not exist" do
    let(:file_or_dir) { finder_fixture_path("only_ruby", "does_not_exist.rb") }

    it "returns files with exists flag of false" do
      expect(subject.to_a).to eql(abs_paths([[false, "only_ruby/does_not_exist.rb"]], finder_fixture_path))
    end
  end

  context "the directory contains gem related files" do
    let(:file_or_dir) { finder_fixture_path("only_gemfiles") }

    it "includes the files" do
      expect(subject.to_a).to match_array(abs_paths([[true, "Gemfile"], [true, "a.gemspec"]]))
    end
  end

  context "the directory contains rake files" do
    let(:file_or_dir) { finder_fixture_path("only_rake_files") }

    it "includes all the rake files" do
      expect(subject.to_a).to match_array(abs_paths([[true, "Rakefile"], [true, "a.rake"]]))
    end
  end

  context "the directory contains vendor directory" do
    let(:file_or_dir) { finder_fixture_path("only_vendor") }

    it "ignores the vendor directory" do
      expect(subject.to_a).to match_array(abs_paths([]))
    end
  end

  context "the directory contains rackup files" do
    let(:file_or_dir) { finder_fixture_path("only_rackup_files") }

    it "includes all the rackup files" do
      expect(subject.to_a).to match_array(abs_paths([[true, "config.ru"]]))
    end
  end

  context "the directory contains erb files" do
    let(:file_or_dir) { finder_fixture_path("only_erb_files") }

    it "includes all the rackup files" do
      expect(subject.to_a).to match_array(abs_paths([[true, "example.erb"]]))
    end
  end

  context "files can be explicitly included" do
    let(:file_or_dir) { finder_fixture_path("mixed_dir") }
    let(:includes) { ["*.txt"] }

    it "returns all the files" do
      expect(subject.to_a).to match_array(
        abs_paths([[true, "a.rb"], [true, "a.txt"]])
      )
    end
  end

  context "files can be explicitly excluded" do
    let(:file_or_dir) { finder_fixture_path("mixed_dir") }
    let(:excludes) { ["*.rb"] }

    it "returns no files" do
      expect(subject.to_a).to match_array(
        []
      )
    end
  end

  def relative_paths(paths, base = file_or_dir)
    paths.map { |(exists, path)| [exists, path.sub("#{base}/", "")] }
  end

  def abs_paths(paths, base = file_or_dir)
    paths.map { |(exists, path)| [exists, File.join(base, path)] }
  end

  def finder_fixture_path(*components)
    File.join(__dir__, "..", "..", "fixtures", "file_finder", *components)
  end
end
