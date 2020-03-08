RSpec.describe Rufo::FileList do
  describe "#to_s" do
    it "lists all the files that are matched" do
      subject.include("exe/*")
      expect(subject.to_s).to eql("exe/rufo")
    end
  end

  describe "#to_a" do
    it "includes files matching exactly" do
      subject.include("exe/rufo")
      expect(subject).to contain_exactly("exe/rufo")
    end

    it "includes files matching glob" do
      subject.include("exe/*")
      expect(subject).to contain_exactly("exe/rufo")
    end

    it "excludes files matching exactly" do
      subject.include("exe/*")
      subject.exclude("exe/rufo")
      expect(subject.to_a).to eql([])
    end

    it "excludes files matching glob" do
      subject.include("exe/*")
      subject.exclude("exe/r*")
      expect(subject.to_a).to eql([])
    end
  end
end
