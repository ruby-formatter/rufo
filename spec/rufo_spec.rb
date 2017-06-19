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

  # Comment
  assert_format "# foo"
  assert_format "# foo\n# bar"
  assert_format "1   # foo", "1 # foo"

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

  # Inline if
  assert_format "1  ?   2    :  3", "1 ? 2 : 3"

  # Suffix if/unless/rescue
  assert_format "1   if  2", "1 if 2"
  assert_format "1   unless  2", "1 unless 2"
  assert_format "1   rescue  2", "1 rescue 2"

  # Variables
  assert_format "a = 1\n  a", "a = 1\na"

  # Instance variable
  assert_format "@foo"

  # Constants and paths
  assert_format "Foo"
  assert_format "Foo::Bar::Baz"
  assert_format "Foo::Bar::Baz"
  assert_format "Foo:: Bar:: Baz", "Foo::Bar::Baz"
  assert_format "Foo:: \nBar", "Foo::Bar"

  # Calls
  assert_format "foo"
  assert_format "foo()"
  assert_format "foo(  )", "foo()"
  assert_format "foo( \n\n )", "foo()"
  assert_format "foo(  1  )", "foo(1)"
  assert_format "foo(  1 ,   2 )", "foo(1, 2)"

  # Semicolons and spaces
  assert_format "123;", "123"
  assert_format "1   ;   2", "1; 2"
  assert_format "1   ;  ;   2", "1; 2"
  assert_format "1  \n  2", "1\n2"
  assert_format "1  \n   \n  2", "1\n\n2"
  assert_format "1  \n ; ; ; \n  2", "1\n\n2"
  assert_format "1 ; \n ; \n ; ; \n  2", "1\n\n2"
end
