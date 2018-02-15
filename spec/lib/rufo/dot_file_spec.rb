require "spec_helper"

RSpec.describe Rufo::DotFile do
  describe "#parse" do
    it "parses booleans" do
      expect(subject.parse("key true\nother false")).to eql(
        key: true,
        other: false,
      )
    end

    it "parses symbols" do
      expect(subject.parse("key :true")).to eql(
        key: :true,
      )
    end

    it "warns about config it cannot parse" do
      result = nil
      expect {
        result = subject.parse("key 1")
      }.to output(%(Unknown config value="1" for "key"\n)).to_stderr

      expect(result).to eql({})
    end
  end
end
