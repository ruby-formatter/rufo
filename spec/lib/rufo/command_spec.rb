require "tempfile"

RSpec.describe Rufo::Command do
  describe "exit codes" do
    matcher :terminate do
      actual = nil

      match do |block|
        begin
          block.call
        rescue SystemExit => e
          actual = e.status
        end
        actual and actual == status_code
      end

      chain :with_code do |status_code|
        @status_code = status_code
      end

      failure_message do |block|
        "expected block to call exit(#{status_code}) but exit" +
          (actual.nil? ? " not called" : "(#{actual}) was called")
      end

      failure_message_when_negated do |block|
        "expected block not to call exit(#{status_code})"
      end

      description do
        "exit(#{status_code})"
      end

      def status_code
        @status_code ||= 0
      end
    end

    describe "files" do
      describe "check" do
        subject { -> { described_class.run(["-c", file]) } }

        context "missing file" do
          let(:file) { "missing.rb" }
          it { is_expected.to terminate.with_code(1) }
        end

        context "unchanged file" do
          let(:file) { "spec/fixtures/valid" }
          it { is_expected.to terminate }
        end

        context "changed file" do
          let(:file) { "spec/fixtures/needs_changes" }
          it { is_expected.to terminate.with_code 3 }
        end

        context "invalid file" do
          let(:file) { "spec/fixtures/syntax_error" }
          it { is_expected.to terminate.with_code 1 }
        end
      end

      describe "format" do
        subject do
          lambda do
            tempfile = File.exist?(file) && Tempfile.new("rufo-fixture")

            if tempfile
              begin
                tempfile.write(File.read(file))
                tempfile.rewind
                described_class.run([tempfile.path])
              rescue SystemExit
                tempfile.close
                tempfile.unlink
                raise
              end
            else
              described_class.run([file])
            end
          end
        end

        context "missing file" do
          let(:file) { "missing.rb" }
          it { is_expected.to terminate.with_code(1) }
        end

        context "unchanged file" do
          let(:file) { "spec/fixtures/valid" }
          it { is_expected.to terminate }
        end

        context "changed file" do
          let(:file) { "spec/fixtures/needs_changes" }
          it { is_expected.to terminate.with_code 3 }
        end

        context "invalid file" do
          let(:file) { "spec/fixtures/syntax_error" }
          it { is_expected.to terminate.with_code 1 }
        end
      end
    end

    describe "STDIN" do
      describe "check" do
        subject { -> { described_class.run(["-c"]) } }
        before(:example) { expect(STDIN).to receive(:read).and_return code }

        context "no code" do
          let(:code) { "" }
          it { is_expected.to terminate.with_code 3 }
        end

        context "unchanged code" do
          let(:code) { "[]\n" }
          it { is_expected.to terminate }
        end

        context "changed code" do
          let(:code) { "[ ]\n" }
          it { is_expected.to terminate.with_code 3 }
        end

        context "invalid code" do
          let(:code) { "not_valid(ruby" }
          it { is_expected.to terminate.with_code 1 }
        end
      end

      describe "format" do
        subject { -> { described_class.run([]) } }
        before(:example) { expect(STDIN).to receive(:read).and_return code }

        context "no code" do
          let(:code) { "" }
          it { is_expected.to terminate.with_code 3 }
        end

        context "unchanged code" do
          let(:code) { "[]\n" }
          it { is_expected.to terminate }
        end

        context "changed code" do
          let(:code) { "[ ]\n" }
          it { is_expected.to terminate.with_code 3 }
        end

        context "invalid code" do
          let(:code) { "not_valid(ruby" }
          it { is_expected.to terminate.with_code 1 }

          it "outputs a useful message" do
            message = "STDIN is invalid code. Error on line:1 syntax error, " \
            "unexpected end-of-input, expecting ')'\n"
            expect {
              begin
                subject.call
              rescue SystemExit
              end
            }.to output(message).to_stderr
          end
        end
      end
    end
  end
end
