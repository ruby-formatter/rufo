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
      when line =~ /^#~# (.+)$/
        current_test[:options] = eval("{ #{$~[1]} }")
      when line =~ /^#/
        next
      when current_test[:expected]
        current_test[:expected] += line
      when current_test[:original]
        current_test[:original] += line
      end
    end

    tests.concat([current_test]).each do |test|
      it "formats #{test[:name]} (line: #{test[:line]})" do
        formatted = Rufa::Formatter.format(test[:original], **test[:options]).strip
        expected = test[:expected].strip

        if expected != formatted
          message = "#{Rufa::Formatter.debug(test[:original], **test[:options])}\n\n" +
                    "#~# EXPECTED\n\n" +
                    expected +
                    "\n\n#~# ACTUAL\n\n" +
                    formatted +
                    "\n\n#~# INSPECT\n\n" +
                    formatted.inspect

          fail message
        end

        expect(formatted).to eq(expected)
      end
    end
  end
end

def assert_format(code, expected)
  it "formats #{code.inspect} to #{expected.inspect}" do
    expect(Rufa::Formatter.format(code)).to eq(expected)
  end
end

RSpec.describe Rufo do
  Dir[File.join(FILE_PATH, "/source_specs/rufa*")].each do |source_specs|
    assert_source_specs(source_specs) if File.file?(source_specs)
  end

  # if VERSION >= Gem::Version.new("2.3")
  #   Dir[File.join(FILE_PATH, "/source_specs/2.3/*")].each do |source_specs|
  #     assert_source_specs(source_specs) if File.file?(source_specs)
  #   end
  # end
end
