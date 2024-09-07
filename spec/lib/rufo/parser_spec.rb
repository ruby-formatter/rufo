RSpec.describe Rufo::Parser do
  subject { described_class.new(engine) }

  context 'ripper' do
    let(:engine) { :ripper }

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

  context 'prism' do
    let(:engine) { :prism }

    it "parses valid code" do
      subject.parse("a = 6")
    end

    context "code is invalid" do
      let(:code) { "a do" }

      it "raises an error with line number information" do
        expect { subject.parse(code) }.to raise_error do |error|
          expect(error).to be_a(Rufo::SyntaxError)
          expect(error.lineno).to be(1)
          expect(error.message).to eql("unexpected end-of-input, assuming it is closing the parent top level context")
        end
      end
    end
  end
end
