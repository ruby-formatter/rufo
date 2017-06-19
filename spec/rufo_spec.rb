require "spec_helper"
require "pp"

def assert_format(code, expected = code)
  expected = expected.rstrip + "\n"

  ex = it "formats #{code.inspect}" do
    actual = Rufo.format(code)
    expect(actual).to eq(expected)
  end

  # This is so we can do `rspec spec/rufo_spec.rb:26` and
  # refer to line numbers for assert_format
  ex.metadata[:line_number] = caller_locations[0].lineno
end

RSpec.describe Rufo do
  # Empty
  assert_format "", ""

  # Nil
  assert_format "nil"

  # Bool
  assert_format "false"
  assert_format "true"

  # String literals
  assert_format "'hello'"
  assert_format %("hello")
  assert_format %Q("hello")
  assert_format %("\\n")
  assert_format %("hello \#{1} foo")
  assert_format %("hello \#{  1   } foo"), %("hello \#{1} foo")

  # Symbol literals
  assert_format ":foo"
  assert_format %(:"foo")
  assert_format %(:"foo\#{1}")

  # Numbers
  assert_format "123"

  # Assignment
  assert_format "a   =   1", "a = 1"

  # Semicolons and spaces
  assert_format "123;", "123"
  assert_format "1   ;   2", "1; 2"
  assert_format "1   ;  ;   2", "1; 2"
  assert_format "1  \n  2", "1\n2"
  assert_format "1  \n   \n  2", "1\n\n2"
  assert_format "1  \n ; ; ; \n  2", "1\n\n2"
  assert_format "1 ; \n ; \n ; ; \n  2", "1\n\n2"
end
