require "fileutils"

VERSION = Gem::Version.new(RUBY_VERSION)
FILE_PATH = Pathname.new(File.dirname(__FILE__))

def assert_source_specs(source_specs)
  relative_path = Pathname.new(source_specs).relative_path_from(FILE_PATH).to_s

  describe relative_path do
    tests = []
    current_test = nil

    File.foreach(source_specs).with_index do |line, index|
      case
      when line =~ /^#~# ORIGINAL ?([\w\s()]+)$/
        # save old test
        tests.push current_test if current_test

        # start a new test

        name = $~[1].strip
        name = "unnamed test" if name.empty?

        current_test = { name: name, line: index + 1, options: {}, original: "" }
      when line =~ /^#~# EXPECTED$/
        current_test[:expected] = ""
      when line =~ /^#~# PENDING$/
        # :nocov:
        current_test[:pending] = true
        # :nocov:
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

        options = test[:options].merge(parser_engine: parser_engine)
        formatted = described_class.format(test[:original], **options)
        expected = test[:expected].rstrip + "\n"
        expect(formatted).to eq(expected)
        idempotency_check = described_class.format(formatted, **options)
        expect(idempotency_check).to eq(formatted)
      end
    end
  end
end

def assert_format(code, expected = code, **options)
  expected = expected.rstrip + "\n"

  line = caller_locations[0].lineno

  ex = it "formats #{code.inspect} (line: #{line})" do
    opts = options.merge(parser_engine:)
    actual = Rufo.format(code, **opts)
    if actual != expected
      fail "Expected\n\n~~~\n#{code}\n~~~\nto format to:\n\n~~~\n#{expected}\n~~~\n\nbut got:\n\n~~~\n#{actual}\n~~~\n\n  diff = #{expected.inspect}\n         #{actual.inspect}"
    end

    second = Rufo.format(actual, **opts)
    if second != actual
      fail "Idempotency check failed. Expected\n\n~~~\n#{actual}\n~~~\nto format to:\n\n~~~\n#{actual}\n~~~\n\nbut got:\n\n~~~\n#{second}\n~~~\n\n  diff = #{second.inspect}\n         #{actual.inspect}"
    end
  end

  # This is so we can do `rspec spec/rufo_spec.rb:26` and
  # refer to line numbers for assert_format
  ex.metadata[:line_number] = line
end

RSpec.describe Rufo::Formatter do
  shared_examples_for 'formatter is works' do
    Dir[File.join(FILE_PATH, "/formatter_source_specs/*")].each do |source_specs|
      assert_source_specs(source_specs) if File.file?(source_specs)
    end

    if VERSION >= Gem::Version.new("3.0")
      Dir[File.join(FILE_PATH, "/formatter_source_specs/3.0/*")].each do |source_specs|
        assert_source_specs(source_specs) if File.file?(source_specs)
      end
    end

    if VERSION >= Gem::Version.new("3.1")
      Dir[File.join(FILE_PATH, "/formatter_source_specs/3.1/*")].each do |source_specs|
        assert_source_specs(source_specs) if File.file?(source_specs)
      end
    end

    if VERSION >= Gem::Version.new("3.2")
      Dir[File.join(FILE_PATH, "/formatter_source_specs/3.2/*")].each do |source_specs|
        assert_source_specs(source_specs) if File.file?(source_specs)
      end
    end

    describe "empty" do
      assert_format "", ""
      assert_format "   ", "   "
      assert_format "\n", ""
      assert_format "\n\n", ""
      assert_format "\n\n\n", ""
    end

    describe "Syntax errors not handled by Ripper" do
      it "raises an unknown syntax error" do
        expect {
          Rufo.format("def foo; FOO = 1; end", parser_engine: parser_engine)
        }.to raise_error(Rufo::UnknownSyntaxError)
      end
    end
  end

  context 'ripper' do
    let(:parser_engine) { :ripper }

    it_behaves_like 'formatter is works'
  end

  context 'prism' do
    let(:parser_engine) { :prism }

    it_behaves_like 'formatter is works'
  end
end
