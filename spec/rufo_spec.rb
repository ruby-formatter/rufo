require "spec_helper"
require "pp"

def assert_format(code, expected = code)
  expected = expected.rstrip + "\n"

  ex = it "formats #{code.inspect}" do
    actual = Rufo.format(code)
    if actual != expected
      fail "Expected\n\n~~~\n#{code}\n~~~\nto format to:\n\n~~~\n#{expected}\n~~~\n\nbut got:\n\n~~~\n#{actual}\n~~~\n\n  assert_format #{code.inspect}, #{actual.inspect}"
    end
  end

  # This is so we can do `rspec spec/rufo_spec.rb:26` and
  # refer to line numbers for assert_format
  ex.metadata[:line_number] = caller_locations[0].lineno
end

RSpec.describe Rufo do
  # Empty
  assert_format "", ""

  # Comments
  assert_format "# foo"
  assert_format "# foo\n# bar"
  assert_format "1   # foo", "1 # foo"
  assert_format "# a\n\n# b"
  assert_format "# a\n\n\n# b", "# a\n\n# b"
  assert_format "# a\n1", "# a\n1"
  assert_format "# a\n\n\n1", "# a\n\n1"
  assert_format "1 # a\n# b"
  assert_format "1 # a\n\n# b"
  assert_format "1 # a\n\n2 # b"
  assert_format "1 # a\n\n\n2 # b", "1 # a\n\n2 # b"
  assert_format "1 # a\n\n\n\n\n\n\n2 # b", "1 # a\n\n2 # b"
  assert_format "1 # a\n\n\n# b\n\n\n # c\n 2 # b", "1 # a\n\n# b\n\n# c\n2 # b"

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
  assert_format %("hello \#{\n1} foo"), %("hello \#{1} foo")

  # Symbol literals
  assert_format ":foo"
  assert_format %(:"foo")
  assert_format %(:"foo\#{1}")

  # Numbers
  assert_format "123"

  # Assignment
  assert_format "a   =   1", "a = 1"
  assert_format "a   =  \n2", "a =\n  2"
  assert_format "a   =   # hello \n2", "a = # hello\n  2"
  assert_format "a =   if 1 \n 2 \n end", "a = if 1\n      2\n    end"
  assert_format "a =   unless 1 \n 2 \n end", "a = unless 1\n      2\n    end"
  assert_format "a =   begin\n1 \n end", "a = begin\n      1\n    end"

  # Multiple assignent (left)
  assert_format "a =   1  ,   2", "a = 1, 2"

  # Inline if
  assert_format "1  ?   2    :  3", "1 ? 2 : 3"

  # Suffix if/unless/rescue
  assert_format "1   if  2", "1 if 2"
  assert_format "1   unless  2", "1 unless 2"
  assert_format "1   rescue  2", "1 rescue 2"

  # If
  assert_format "if 1\n2\nend", "if 1\n  2\nend"
  assert_format "if 1\n\n2\n\nend", "if 1\n  2\nend"
  assert_format "if 1\n\nend", "if 1\nend"
  assert_format "if 1;end", "if 1\nend"
  assert_format "if 1 # hello\nend", "if 1 # hello\nend"
  assert_format "if 1 # hello\n\nend", "if 1 # hello\n\nend"
  assert_format "if 1 # hello\n1\nend", "if 1 # hello\n  1\nend"
  assert_format "if 1;# hello\n1\nend", "if 1 # hello\n  1\nend"
  assert_format "if 1 # hello\n # bye\nend", "if 1 # hello\n  # bye\nend"
  assert_format "if 1; 2; else; end", "if 1\n  2\nelse\nend"
  assert_format "if 1; 2; else; 3; end", "if 1\n  2\nelse\n  3\nend"
  assert_format "if 1; 2; else # comment\n 3; end", "if 1\n  2\nelse # comment\n  3\nend"
  assert_format "begin\nif 1\n2\nelse\n3\nend\nend", "begin\n  if 1\n    2\n  else\n    3\n  end\nend"

  # Unless
  assert_format "unless 1\n2\nend", "unless 1\n  2\nend"
  assert_format "unless 1\n2\nelse\nend", "unless 1\n  2\nelse\nend"

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

  # Unary operators
  assert_format "- x", "-x"
  assert_format "+ x", "+x"

  # Binary operators
  assert_format "1   +   2", "1 + 2"
  assert_format "1+2", "1 + 2"
  assert_format "1   +  \n 2", "1 +\n  2"
  assert_format "1   +  # hello \n 2", "1 + # hello\n  2"
  assert_format "1 +\n2+\n3", "1 +\n  2 +\n  3"
  assert_format "1  &&  2", "1 && 2"
  assert_format "1  ||  2", "1 || 2"
  assert_format "1*2", "1*2"
  assert_format "1* 2", "1*2"
  assert_format "1 *2", "1 * 2"
  assert_format "1/2", "1/2"
  assert_format "1**2", "1**2"

  # Class
  assert_format "class   Foo  \n  end", "class Foo\nend"
  assert_format "class   Foo  < Bar \n  end", "class Foo < Bar\nend"
  assert_format "class Foo\n\n1\n\nend", "class Foo\n  1\nend"
  assert_format "class Foo  ;  end", "class Foo; end"
  assert_format "class Foo; \n  end", "class Foo\nend"
  
  # Module
  assert_format "module   Foo  \n  end", "module Foo\nend"
  assert_format "module Foo ; end", "module Foo; end"

  # Semicolons and spaces
  assert_format "123;", "123"
  assert_format "1   ;   2", "1; 2"
  assert_format "1   ;  ;   2", "1; 2"
  assert_format "1  \n  2", "1\n2"
  assert_format "1  \n   \n  2", "1\n\n2"
  assert_format "1  \n ; ; ; \n  2", "1\n\n2"
  assert_format "1 ; \n ; \n ; ; \n  2", "1\n\n2"
  assert_format "123; # hello", "123 # hello"
  assert_format "1;\n2", "1\n2"

  # begin/end
  assert_format "begin; end", "begin\nend"
  assert_format "begin; 1; end", "begin\n  1\nend"
  assert_format "begin\n 1 \n end", "begin\n  1\nend"
  assert_format "begin\n 1 \n 2 \n end", "begin\n  1\n  2\nend"
  assert_format "begin \n begin \n 1 \n end \n 2 \n end", "begin\n  begin\n    1\n  end\n  2\nend"
  assert_format "begin # hello\n end", "begin # hello\nend"
  assert_format "begin;# hello\n end", "begin # hello\nend"
  assert_format "begin\n 1  # a\nend", "begin\n  1 # a\nend"
  assert_format "begin\n 1  # a\n # b \n 3 # c \n end", "begin\n  1 # a\n  # b\n  3 # c\nend"
  assert_format "begin\nend\n\n# foo"

  # begin/rescue/end
  assert_format "begin \n 1 \n rescue \n 2 \n end", "begin\n  1\nrescue\n  2\nend"
  assert_format "begin \n 1 \n rescue   Foo \n 2 \n end", "begin\n  1\nrescue Foo\n  2\nend"
  assert_format "begin \n 1 \n rescue  =>   ex  \n 2 \n end", "begin\n  1\nrescue => ex\n  2\nend"
  assert_format "begin \n 1 \n rescue  Foo  =>  ex \n 2 \n end", "begin\n  1\nrescue Foo => ex\n  2\nend"
  assert_format "begin \n 1 \n rescue  Foo  , Bar , Baz =>  ex \n 2 \n end", "begin\n  1\nrescue Foo, Bar, Baz => ex\n  2\nend"
  assert_format "begin \n 1 \n ensure \n 2 \n end", "begin\n  1\nensure\n  2\nend"
  assert_format "begin \n 1 \n else \n 2 \n end", "begin\n  1\nelse\n  2\nend"

  # Parentheses
  assert_format "  ( 1 ) ", "(1)"
  assert_format "  ( 1 ; 2 ) ", "(1; 2)"

  # Method definition
  assert_format "  def   foo \n end", "def foo\nend"
  assert_format "  def   foo() \n end", "def foo\nend"
  assert_format "  def   foo ( \n ) \n end", "def foo\nend"
  assert_format "  def   foo ( x ) \n end", "def foo(x)\nend"
  assert_format "  def   foo ( x , y ) \n end", "def foo(x, y)\nend"
  assert_format "  def   foo x \n end", "def foo(x)\nend"
  assert_format "  def   foo x , y \n end", "def foo(x, y)\nend"
  assert_format "  def   foo \n 1 \n end", "def foo\n  1\nend"
  assert_format "  def   foo( * x ) \n 1 \n end", "def foo(*x)\n  1\nend"
  assert_format "  def   foo( a , * x ) \n 1 \n end", "def foo(a, *x)\n  1\nend"
  assert_format "  def   foo( a , * x, b ) \n 1 \n end", "def foo(a, *x, b)\n  1\nend"

  # Multiple classes, modules and methods are separated with two lines
  assert_format "def foo\nend\ndef bar\nend", "def foo\nend\n\ndef bar\nend"
  assert_format "class Foo\nend\nclass Bar\nend", "class Foo\nend\n\nclass Bar\nend"
  assert_format "module Foo\nend\nmodule Bar\nend", "module Foo\nend\n\nmodule Bar\nend"
end
