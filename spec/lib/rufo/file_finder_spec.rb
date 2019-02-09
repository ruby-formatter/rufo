require "spec_helper"

RSpec.describe Rufo::FileFinder do
  subject { described_class.new([file_or_dir]) }

  context "the directory contains .rb files" do
    let(:file_or_dir) { finder_fixture_path("only_ruby") }

    it "returns all the .rb files in a directory" do
      expect(relative_paths(subject.to_a)).to eql([[true, "a.rb"]])
    end
  end

  context "the directory does not exist" do
    let(:file_or_dir) { finder_fixture_path("does_not_exist") }

    it "returns paths with exists flag of false" do
      expect(relative_paths(subject.to_a, finder_fixture_path)).to eql([[false, "does_not_exist"]])
    end
  end

  context "the argument is a file" do
    let(:file_or_dir) { finder_fixture_path("only_ruby", "a.rb") }

    it "returns file provided" do
      expect(relative_paths(subject.to_a, finder_fixture_path)).to eql([[true, "only_ruby/a.rb"]])
    end
  end

  context "the argument is a file that does not exist" do
    let(:file_or_dir) { finder_fixture_path("only_ruby", "does_not_exist.rb") }

    it "returns files with exists flag of false" do
      expect(relative_paths(subject.to_a, finder_fixture_path)).to eql([[false, "only_ruby/does_not_exist.rb"]])
    end
  end

  context "the directory contains gem related files" do
    let(:file_or_dir) { finder_fixture_path("only_gemfiles") }

    it "includes the files" do
      expect(relative_paths(subject.to_a)).to match_array([[true, "Gemfile"], [true, "a.gemspec"]])
    end
  end

  context "the directory contains rake files" do
    let(:file_or_dir) { finder_fixture_path("only_rake_files") }

    it "includes all the rake files" do
      expect(relative_paths(subject.to_a)).to match_array([[true, "Rakefile"], [true, "a.rake"]])
    end
  end

  def relative_paths(paths, base = file_or_dir)
    paths.map { |(exists, path)| [exists, path.sub("#{base}/", "")] }
  end

  def finder_fixture_path(*components)
    File.join(__dir__, "..", "..", "fixtures", "file_finder", *components)
  end
end
