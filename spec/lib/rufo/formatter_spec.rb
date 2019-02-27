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

  # Empty
  describe "empty" do
    assert_format "", ""
    assert_format "   ", "   "
    assert_format "\n", ""
    assert_format "\n\n", ""
    assert_format "\n\n\n", ""
  end
end
