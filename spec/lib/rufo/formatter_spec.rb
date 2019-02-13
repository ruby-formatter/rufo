require "spec_helper"
require "fileutils"
require_relative "../../support/spec_parser"

VERSION = Gem::Version.new(RUBY_VERSION)
FILE_PATH = Pathname.new(__dir__)

def assert_source_specs(source_specs)
  relative_path = Pathname.new(source_specs).relative_path_from(FILE_PATH).to_s

  describe relative_path do
    full_path = File.expand_path(relative_path, __dir__)
    tests = SpecParser.parse(full_path)

    tests.each do |test|
      it "formats #{test[:name]} (line: #{test[:line]})" do
        pending if test[:pending]
        formatted = described_class.format(test[:original], **test[:options])
        expected = test[:expected].rstrip + "\n"
        expect(formatted).to eq(expected)
        idempotency_check = described_class.format(formatted, **test[:options])
        expect(idempotency_check).to eq(formatted)
      end
    end
  end
end

def assert_format(code, expected = code, **options)
  expected = expected.rstrip + "\n"

  line = caller_locations[0].lineno

  ex = it "formats #{code.inspect} (line: #{line})" do
    actual = Rufo.format(code, **options)
    if actual != expected
      fail "Expected\n\n~~~\n#{code}\n~~~\nto format to:\n\n~~~\n#{expected}\n~~~\n\nbut got:\n\n~~~\n#{actual}\n~~~\n\n  diff = #{expected.inspect}\n         #{actual.inspect}"
    end

    second = Rufo.format(actual, **options)
    if second != actual
      fail "Idempotency check failed. Expected\n\n~~~\n#{actual}\n~~~\nto format to:\n\n~~~\n#{actual}\n~~~\n\nbut got:\n\n~~~\n#{second}\n~~~\n\n  diff = #{second.inspect}\n         #{actual.inspect}"
    end
  end

  # This is so we can do `rspec spec/rufo_spec.rb:26` and
  # refer to line numbers for assert_format
  ex.metadata[:line_number] = line
end

RSpec.describe Rufo::Formatter do
  Dir[File.join(FILE_PATH, "/formatter_source_specs/*")].each do |source_specs|
    assert_source_specs(source_specs) if File.file?(source_specs)
  end

  if VERSION >= Gem::Version.new("2.3")
    Dir[File.join(FILE_PATH, "/formatter_source_specs/2.3/*")].each do |source_specs|
      assert_source_specs(source_specs) if File.file?(source_specs)
    end
  end

  # Empty
  describe "empty" do
    assert_format "", ""
    assert_format "   ", "   "
    assert_format "\n", ""
    assert_format "\n\n", ""
    assert_format "\n\n\n", ""
  end

  describe "Ensure broken Ripper versions detected" do
    it "ensures broken_ripper_version? returns true for broken Ruby versions" do
      fmtr = Rufo::Formatter.new("")
      ["2.3.0", "2.3.1", "2.3.2", "2.3.3", "2.3.4", "2.4.0", "2.4.1"].each do |version|
        stub_const("RUBY_VERSION", version)
        expect(fmtr.broken_ripper_version?).to eq(true)
      end
    end

    it "ensures broken_ripper_version? returns false for fixed Ruby versions" do
      fmtr = Rufo::Formatter.new("")
      ["2.3.5", "2.4.2"].each do |version|
        stub_const("RUBY_VERSION", version)
        expect(fmtr.broken_ripper_version?).to eq(false)
      end
    end

    it "checks current recommended Ruby 2.3 is relevant" do
      expect(RUBY_VERSION).to eq("2.3.7") if RUBY_VERSION[0..2] == "2.3"
    end

    it "checks current recommended Ruby 2.4 is relevant" do
      expect(RUBY_VERSION).to eq("2.4.4") if RUBY_VERSION[0..2] == "2.4"
    end

    it "checks backported Ruby 2.3 is relevant" do
      if RUBY_VERSION[0..2] == "2.3"
        expect(Rufo::Command.new(false, true, "").backported_version).to eq("2.3.7")
      end
    end

    it "checks backported Ruby 2.4 is relevant" do
      if RUBY_VERSION[0..2] == "2.4"
        expect(Rufo::Command.new(false, true, "").backported_version).to eq("2.4.4")
      end
    end
  end
end
