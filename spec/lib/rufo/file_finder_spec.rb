require "spec_helper"

RSpec.describe Rufo::FileFinder do
  subject { described_class.new([file_or_dir]) }

  context 'the directory contains .rb files' do
    let(:file_or_dir) { finder_fixture_path('only_ruby') }

    it 'returns all the .rb files in a directory' do
      expect(relative_paths(subject.to_a)).to eql(['a.rb'])
    end
  end

  context 'the directory does not exist' do
    let(:file_or_dir) { finder_fixture_path('does_not_exist') }

    it 'returns no files' do
      expect(subject.to_a).to eql([])
    end

    it 'exposes the list of directories that do not exist' do
      subject.to_a

      expect(relative_paths(subject.not_found, finder_fixture_path)).to eql(['does_not_exist'])
    end
  end

  context 'the argument is a file' do
    let(:file_or_dir) { finder_fixture_path('only_ruby', 'a.rb') }

    it 'returns file provided' do
      expect(relative_paths(subject.to_a, finder_fixture_path)).to eql(['only_ruby/a.rb'])
    end
  end

  context 'the argument is a file that does not exist' do
    let(:file_or_dir) { finder_fixture_path('only_ruby', 'does_not_exist.rb') }

    it 'returns no files' do
      expect(subject.to_a).to eql([])
    end
  end

  def relative_paths(paths, base = file_or_dir)
    paths.map {|p| p.sub("#{base}/", '') }
  end

  def finder_fixture_path(*components)
    File.join(__dir__, '..', '..', 'fixtures', 'file_finder', *components)
  end
end
