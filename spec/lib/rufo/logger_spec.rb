RSpec.describe Rufo::Logger do
  subject { described_class.new(level) }

  let(:level) { :debug }

  it "logs all levels" do
    expect {
      subject.log("a")
      subject.debug("b")
    }.to output("a\nb\n").to_stdout

    expect {
      subject.warn("c")
      subject.error("d")
    }.to output("c\nd\n").to_stderr
  end

  context "when set to log" do
    let(:level) { :log }

    it "logs all levels except debug" do
      expect {
        subject.log("a")
        subject.debug("b")
      }.to output("a\n").to_stdout

      expect {
        subject.warn("c")
        subject.error("d")
      }.to output("c\nd\n").to_stderr
    end
  end

  context "when set to warn" do
    let(:level) { :warn }

    it "logs only warn and error levels" do
      expect {
        subject.log("a")
        subject.debug("b")
      }.to output("").to_stdout

      expect {
        subject.warn("c")
        subject.error("d")
      }.to output("c\nd\n").to_stderr
    end
  end

  context "when set to error" do
    let(:level) { :error }

    it "logs only error levels" do
      expect {
        subject.log("a")
        subject.debug("b")
      }.to output("").to_stdout

      expect {
        subject.warn("c")
        subject.error("d")
      }.to output("d\n").to_stderr
    end
  end

  context "when set to silent" do
    let(:level) { :silent }

    it "does not log anything" do
      expect {
        subject.log("a")
        subject.debug("b")
      }.to output("").to_stdout

      expect {
        subject.warn("c")
        subject.error("d")
      }.to output("").to_stderr
    end
  end
end
