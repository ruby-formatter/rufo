require "spec_helper"
require "fileutils"

VERSION = Gem::Version.new(RUBY_VERSION)
FILE_PATH = Pathname.new(File.dirname(__FILE__))

def assert_source_specs(source_specs)
  relative_path = Pathname.new(source_specs).relative_path_from(FILE_PATH).to_s

  describe relative_path do
    tests = []
    current_test = nil
    ignore_next_line = false

    File.foreach(source_specs).with_index do |line, index|
      case
      when line =~ /^#~# ORIGINAL ?([\w\s]+)$/
        # save old test
        tests.push current_test if current_test

        # start a new test

        name = $~[1].strip
        name = "unnamed test" if name.empty?

        current_test = {name: name, line: index + 1, options: {}, original: ""}
      when line =~ /^#~# EXPECTED$/
        current_test[:expected] = ""
      when line =~ /^#~# PENDING$/
        current_test[:pending] = true
      when line =~ /^#~# (.+)$/
        current_test[:options] = eval("{ #{$~[1]} }")
      when current_test[:expected]
        current_test[:expected] += line
      when current_test[:original]
        current_test[:original] += line
      end
    end

    tests.concat([current_test]).each do |test|
      it "formats #{test[:name]} (line: #{test[:line]})" do
        pending if test[:pending]
        formatted = described_class.format(test[:original], **test[:options])
        expected = test[:expected].rstrip + "\n"
        expect(formatted).to eq(expected)
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
end
