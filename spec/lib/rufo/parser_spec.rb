RSpec.describe Rufo::Parser do
  subject { described_class }

  it "parses valid code" do
    subject.parse("a = 6")
  end

  context "code is invalid" do
    let(:code) { "a do" }

    it "raises an error with line number information" do
      expect { subject.parse(code) }.to raise_error do |error|
        expect(error).to be_a(Rufo::SyntaxError)
        expect(error.lineno).to be(1)
        expect(error.message).to eql("syntax error, unexpected end-of-input")
      end
    end
  end
end
