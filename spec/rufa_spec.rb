require "spec_helper"
require "fileutils"
require_relative "../lib/rufe"

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
      when line =~ /^#~# ORIGINAL ?(skip ?)?(.*)$/
        # save old test
        tests.push current_test if current_test

        # start a new test

        skip = !!$~[1]
        name = $~[2].strip
        name = "unnamed test" if name.empty?

        current_test = {name: name, line: index + 1, options: {}, original: "",skip: skip}
      when line =~ /^#~# EXPECTED$/
        current_test[:expected] = ""
      when line =~ /^#~# (.+)$/
        current_test[:options] = eval("{ #{$~[1]} }")
      when current_test[:expected]
        current_test[:expected] += line
      when current_test[:original]
        current_test[:original] += line
      end
    end

    (tests + [current_test]).each do |test|
      it "formats #{test[:name]} (line: #{test[:line]})" do
        skip if test[:skip]
        error = nil

        begin
          formatted = Rufe::Formatter.format(test[:original], **test[:options]).to_s.strip
        rescue StandardError => e
          error = e
          formatted = ""
        end

        expected = test[:expected].strip

        if expected != formatted
          # message = "#{Rufi::Formatter.debug(test[:original], **test[:options])}\n\n" +
                    # "#{Rufi::Formatter.format(test[:original], **test[:options]).ai(index: false)}\n\n" +

          message = if test[:options].any?
                       "#~# OPTIONS\n\n" + test[:options].ai
                     else
                       ""
                     end

          message += "\n\n#~# ORIGINAL\n" +
                     test[:original] +
                     "#~# EXPECTED\n\n" +
                     expected +
                     "\n\n#~# ACTUAL\n\n" +
                     formatted +
                     "\n\n#~# INSPECT\n\n" +
                     formatted.inspect

          if error
            puts message
            fail error
          else
            fail message
          end
        end

        expect(formatted).to eq(expected)
      end
    end
  end
end

def assert_format(code, expected)
  it "formats #{code.inspect} to #{expected.inspect}" do
    expect(Rufe::Formatter.format(code)).to eq(expected)
  end
end

RSpec.describe Rufo do
  Dir[File.join(FILE_PATH, "/source_specs/rufi*")].each do |source_specs|
    assert_source_specs(source_specs) if File.file?(source_specs)
  end

  %w(array_literal hash_literal).each do |source_spec_name|
    file = File.join(FILE_PATH, "/source_specs/#{source_spec_name}.rb.spec")
    fail "missing #{source_spec_name}" unless File.exist?(file)
    assert_source_specs(file) if File.file?(file)
  end

  Dir[File.join(FILE_PATH, "/source_specs/*")].sort.take(5).each do |source_specs|
    assert_source_specs(source_specs) if File.file?(source_specs)
  end

  # it "needing break" do
  #   Token = Rufi::Token

  #   hash = Rufi::TokenGroupToLexHash.call([Token.new("hi")])

  #   expect(hash[:needs_break]).to eq(false)

  #   hash = Rufi::TokenGroupToLexHash.call(
  #     [
  #       Token.new("this big long thing"),
  #       Rufi::LINE,
  #       Token.new("this big long thing"),
  #       Rufi::LINE,
  #       Token.new("this big long thing"),
  #       Rufi::LINE,
  #       Token.new("this big long thing"),
  #       Rufi::LINE,
  #       Token.new("this big long thing"),
  #       Rufi::LINE,
  #       Token.new("this big long thing"),
  #       Rufi::LINE,
  #       Token.new("this big long thing"),
  #       Rufi::LINE,
  #     ]
  #   )

  #   expect(hash[:needs_break]).to eq(true)

  #   elements = hash[:lex_elements]

  #   expect(elements.map(&:line).uniq.length).to eq(elements.length)
  # end

  # if VERSION >= Gem::Version.new("2.3")
  #   Dir[File.join(FILE_PATH, "/source_specs/2.3/*")].each do |source_specs|
  #     assert_source_specs(source_specs) if File.file?(source_specs)
  #   end
  # end
end
