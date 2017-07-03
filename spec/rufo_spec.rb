require "spec_helper"

VERSION = Gem::Version.new(RUBY_VERSION)

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

RSpec.describe Rufo do
  # Empty
  assert_format "", ""
  assert_format "   ", "   "
  assert_format "\n", ""
  assert_format "\n\n", ""
  assert_format "\n\n\n", ""

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

  # =begin comment
  assert_format "=begin\n  foo\n  bar\n=end"
  assert_format "1\n\n=begin\n  foo\n  bar\n=end\n\n2"
  assert_format "# foo\n=begin\nbar\n=end"

  # Nil
  assert_format "nil"

  # Bool
  assert_format "false"
  assert_format "true"

  # Char
  assert_format "?a"

  # String literals
  assert_format "'hello'"
  assert_format %("hello")
  assert_format %Q("hello")
  assert_format %("\\n")
  assert_format %("hello \#{1} foo")
  assert_format %("hello \#{  1   } foo"), %("hello \#{1} foo")
  assert_format %("hello \#{\n1} foo"), %("hello \#{1} foo")
  assert_format %("\#@foo")
  assert_format %("\#@@foo")
  assert_format %("\#$foo")

  # String concatenation
  assert_format %("foo"   "bar"), %("foo" "bar")
  assert_format %("foo" \\\n "bar"), %("foo" \\\n"bar")
  assert_format %(x 1, "foo" \\\n     "bar")

  # Heredoc
  assert_format "<<-EOF\n  foo\n  bar\nEOF"
  assert_format "foo 1 , <<-EOF , 2 \n  foo\n  bar\nEOF", "foo 1, <<-EOF, 2\n  foo\n  bar\nEOF"
  assert_format "foo 1 , <<-EOF1 , 2 , <<-EOF2 , 3 \n  foo\n  bar\nEOF1\n  baz \nEOF2", "foo 1, <<-EOF1, 2, <<-EOF2, 3\n  foo\n  bar\nEOF1\n  baz \nEOF2"
  assert_format "foo 1 , <<-EOF1 , 2 , <<-EOF2 \n  foo\n  bar\nEOF1\n  baz \nEOF2", "foo 1, <<-EOF1, 2, <<-EOF2\n  foo\n  bar\nEOF1\n  baz \nEOF2"
  assert_format "foo(1 , <<-EOF , 2 )\n  foo\n  bar\nEOF", "foo(1, <<-EOF, 2)\n  foo\n  bar\nEOF"
  assert_format "<<-EOF.foo\n  bar\nEOF"
  assert_format "x = <<-EOF.foo\n  bar\nEOF"
  assert_format "x, y = <<-EOF.foo, 2\n  bar\nEOF"
  assert_format "call <<-EOF.foo, y\n  bar\nEOF"
  assert_format "<<-EOF\n  foo\nEOF\n\n# comment"
  assert_format "foo(<<-EOF)\n  bar\nEOF"
  assert_format "foo <<-EOF.bar if 1\n  x\nEOF"
  assert_format "<<-EOF % 1\n  bar\nEOF"
  assert_format "{1 => <<EOF,\ntext\nEOF\n 2 => 3}"

  if VERSION >= Gem::Version.new("2.3")
    assert_format "[\n  [<<~'},'] # comment\n  },\n]", "[\n  [<<~'},'], # comment\n  },\n]"
    assert_format "[\n  [<<~'},'], # comment\n  },\n]"
    assert_format "[\n  [<<~'},'], # comment\n  },\n  2,\n]"
    assert_format "[\n  [<<~EOF] # comment\n  EOF\n]", "[\n  [<<~EOF], # comment\n  EOF\n]"
    assert_format "begin\n  foo = <<~STR\n    some\n\n    thing\n  STR\nend"

    # Heredoc with tilde
    assert_format "<<~EOF\n  foo\n   bar\nEOF", "<<~EOF\n  foo\n   bar\nEOF"
    assert_format "<<~EOF\n  \#{1}\n   bar\nEOF"
    assert_format "begin \n <<~EOF\n  foo\n   bar\nEOF\n end", "begin\n  <<~EOF\n    foo\n     bar\n  EOF\nend"
  end

  # Command execution
  assert_format "`cat meow`"
  assert_format " %x( cat meow )", "%x( cat meow )"

  # Symbol literals
  assert_format ":foo"
  assert_format %(:"foo")
  assert_format %(:"foo\#{1}")
  assert_format ":*"

  # Integer
  assert_format "123"

  # Float
  assert_format "12.34"
  assert_format "12.34e-10"

  # Rational
  assert_format "3.141592r"

  # Imaginary
  assert_format "3.141592i"

  # Assignment
  assert_format "a   =   1"
  assert_format "a   =  \n2", "a   =\n  2"
  assert_format "a   =   # hello \n2", "a   = # hello\n  2"
  assert_format "a = if 1 \n 2 \n end", "a = if 1\n      2\n    end"
  assert_format "a = unless 1 \n 2 \n end", "a = unless 1\n      2\n    end"
  assert_format "a = begin\n1 \n end", "a = begin\n  1\nend"
  assert_format "a = case\n when 1 \n 2 \n end", "a = case\n    when 1\n      2\n    end"
  assert_format "a = begin\n1\nend", "a = begin\n  1\nend"
  assert_format "a = begin\n1\nrescue\n2\nend", "a = begin\n      1\n    rescue\n      2\n    end"
  assert_format "a = begin\n1\nensure\n2\nend", "a = begin\n      1\n    ensure\n      2\n    end"
  assert_format "a=1"
  assert_format "a = \\\n  begin\n    1\n  end", "a =\n  begin\n    1\n  end"

  # Multiple assignent
  assert_format "a  =   1  ,   2", "a  =   1,   2"
  assert_format "a , b  = 2 ", "a, b  = 2"
  assert_format "a , b, ( c, d )  = 2 ", "a, b, (c, d)  = 2"
  assert_format " *x = 1", "*x = 1"
  assert_format " a , b , *x = 1", "a, b, *x = 1"
  assert_format " *x , a , b = 1", "*x, a, b = 1"
  assert_format " a, b, *x, c, d = 1", "a, b, *x, c, d = 1"
  assert_format "a, b, = 1"
  assert_format "a = b, *c"
  assert_format "a = b, *c, *d"
  assert_format "a, = b"
  assert_format "a = b, c, *d"
  assert_format "a = b, c, *d, e"
  assert_format "*, y = z"
  assert_format "w, (x,), y = z"
  assert_format "a, b=1, 2"
  assert_format "* = 1"

  # Assign + op
  assert_format "a += 2"
  assert_format "a += \n 2", "a +=\n  2"
  assert_format "a+=1"

  # Ternary if
  assert_format "1  ?   2    :  3"
  assert_format "1 ? \n 2 : 3", "1 ?\n  2 : 3"
  assert_format "1 ? 2 : \n 3", "1 ? 2 :\n  3"
  assert_format "1?2:3"

  # Suffix if/unless/rescue/while/until
  assert_format "1 if 2", "1 if 2"
  assert_format "1 unless 2", "1 unless 2"
  assert_format "1 rescue 2", "1 rescue 2"
  assert_format "1 while 2", "1 while 2"
  assert_format "1 until 2", "1 until 2"
  assert_format "x.y rescue z", "x.y rescue z"
  assert_format "1  if  2"
  assert_format "foo bar(1)  if  2"

  assert_format "URI(string) rescue return"
  assert_format "URI(string) while return"
  assert_format "URI(string) if return"
  assert_format "URI(string) unless return"

  # If
  assert_format "if 1\n2\nend", "if 1\n  2\nend"
  assert_format "if 1\n\n2\n\nend", "if 1\n  2\nend"
  assert_format "if 1\n\nend", "if 1\nend"
  assert_format "if 1;end", "if 1; end"
  assert_format "if 1 # hello\nend", "if 1 # hello\nend"
  assert_format "if 1 # hello\n\nend", "if 1 # hello\nend"
  assert_format "if 1 # hello\n1\nend", "if 1 # hello\n  1\nend"
  assert_format "if 1;# hello\n1\nend", "if 1 # hello\n  1\nend"
  assert_format "if 1 # hello\n # bye\nend", "if 1 # hello\n  # bye\nend"
  assert_format "if 1; 2; else; end"
  assert_format "if 1; 2; else; 3; end"
  assert_format "if 1; 2; else # comment\n 3; end", "if 1; 2; else # comment\n  3\nend"
  assert_format "begin\nif 1\n2\nelse\n3\nend\nend", "begin\n  if 1\n    2\n  else\n    3\n  end\nend"
  assert_format "if 1 then 2 else 3 end", "if 1 then 2 else 3 end"
  assert_format "if 1 \n 2 \n elsif 3 \n 4 \n end", "if 1\n  2\nelsif 3\n  4\nend"
  assert_format "if 1\nthen 2\nend", "if 1\n  2\nend"

  # Unless
  assert_format "unless 1\n2\nend", "unless 1\n  2\nend"
  assert_format "unless 1\n2\nelse\nend", "unless 1\n  2\nelse\nend"

  # While
  assert_format "while 1 ; end", "while 1; end"
  assert_format "while 1 ; 2 ; end", "while 1; 2; end"
  assert_format "while 1 \n end", "while 1\nend"
  assert_format "while 1 \n 2 \n 3 \n end", "while 1\n  2\n  3\nend"
  assert_format "while 1  # foo \n 2 \n 3 \n end", "while 1 # foo\n  2\n  3\nend"
  assert_format "while 1 do  end", "while 1 do end"
  assert_format "while 1 do  2  end", "while 1 do 2 end"
  assert_format "begin \n while 1  do  2  end \n end", "begin\n  while 1 do 2 end\nend"

  # Until
  assert_format "until 1 ; end", "until 1; end"

  # Case
  assert_format "case \n when 1 then 2 \n end", "case\nwhen 1 then 2\nend"
  assert_format "case \n when 1 then 2 \n when 3 then 4 \n end", "case\nwhen 1 then 2\nwhen 3 then 4\nend"
  assert_format "case \n when 1 then 2 else 3 \n end", "case\nwhen 1 then 2\nelse 3\nend"
  assert_format "case \n when 1 ; 2 \n end", "case\nwhen 1; 2\nend"
  assert_format "case \n when 1 \n 2 \n end", "case\nwhen 1\n  2\nend"
  assert_format "case \n when 1 \n 2 \n 3 \n end", "case\nwhen 1\n  2\n  3\nend"
  assert_format "case \n when 1 \n 2 \n 3 \n when 4 \n 5 \n end", "case\nwhen 1\n  2\n  3\nwhen 4\n  5\nend"
  assert_format "case 123 \n when 1 \n 2 \n end", "case 123\nwhen 1\n  2\nend"
  assert_format "case  # foo \n when 1 \n 2 \n end", "case # foo\nwhen 1\n  2\nend"
  assert_format "case \n when 1  # comment \n 2 \n end", "case\nwhen 1 # comment\n  2\nend"
  assert_format "case \n when 1 then 2 else \n 3 \n end", "case\nwhen 1 then 2\nelse\n  3\nend"
  assert_format "case \n when 1 then 2 else ; \n 3 \n end", "case\nwhen 1 then 2\nelse\n  3\nend"
  assert_format "case \n when 1 then 2 else  # comm \n 3 \n end", "case\nwhen 1 then 2\nelse # comm\n  3\nend"
  assert_format "begin \n case \n when 1 \n 2 \n when 3 \n 4 \n  else \n 5 \n end \n end", "begin\n  case\n  when 1\n    2\n  when 3\n    4\n  else\n    5\n  end\nend"
  assert_format "case \n when 1 then \n 2 \n end", "case\nwhen 1\n  2\nend"
  assert_format "case \n when 1 then ; \n 2 \n end", "case\nwhen 1\n  2\nend"
  assert_format "case \n when 1 ; \n 2 \n end", "case\nwhen 1\n  2\nend"
  assert_format "case \n when 1 , \n 2 ; \n 3 \n end", "case\nwhen 1,\n     2\n  3\nend"
  assert_format "case \n when 1 , 2,  # comm\n \n 3 \n end", "case\nwhen 1, 2, # comm\n     3\nend"
  assert_format "begin \n case \n when :x \n # comment \n 2 \n end \n end", "begin\n  case\n  when :x\n    # comment\n    2\n  end\nend"
  assert_format "case 1\n when *x , *y \n 2 \n end", "case 1\nwhen *x, *y\n  2\nend"
  assert_format "case 1\nwhen *x then 2\nend"
  assert_format "case 1\nwhen  2  then  3\nend"

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
  assert_format "::Foo"
  assert_format "::Foo::Bar"
  assert_format "::Foo = 1"
  assert_format "::Foo::Bar = 1"

  # Calls
  assert_format "foo"
  assert_format "foo()"
  assert_format "foo ()"
  assert_format "foo(  )", "foo()"
  assert_format "foo( \n\n )", "foo()"
  assert_format "foo(  1  )", "foo(1)"
  assert_format "foo(  1 ,   2 )", "foo(1,   2)"
  assert_format "foo  1"
  assert_format "foo  1,  2"
  assert_format "foo  1,  *x"
  assert_format "foo  1,  *x , 2  ", "foo  1,  *x, 2"
  assert_format "foo  1,  *x , 2 , 3 ", "foo  1,  *x, 2, 3"
  assert_format "foo  1,  *x , 2 , 3 , *z , *w , 4", "foo  1,  *x, 2, 3, *z, *w, 4"
  assert_format "foo *x ", "foo *x"
  assert_format "foo 1, \n  *x ", "foo 1,\n  *x"
  assert_format "foo 1,  *x , *y ", "foo 1,  *x, *y"
  assert_format "foo 1,  **x"
  assert_format "foo 1,  \n **x", "foo 1,\n    **x"
  assert_format "foo 1,  **x , **y", "foo 1,  **x, **y"
  assert_format "foo 1,  bar:  2 , baz:  3", "foo 1,  bar:  2, baz:  3"
  assert_format "foo 1, \n bar:  2 , baz:  3", "foo 1,\n    bar:  2, baz:  3"
  assert_format "foo 1, \n 2", "foo 1,\n    2"
  assert_format "foo(1, \n 2)", "foo(1,\n    2)"
  assert_format "foo(\n1, \n 2)", "foo(\n  1,\n  2\n)"
  assert_format "foo(\n1, \n 2,)", "foo(\n  1,\n  2,\n)"
  assert_format "foo(\n1, \n 2 \n)", "foo(\n  1,\n  2\n)"
  assert_format "begin\n foo(\n1, \n 2 \n) \n end", "begin\n  foo(\n    1,\n    2\n  )\nend"
  assert_format "begin\n foo(1, \n 2 \n ) \n end", "begin\n  foo(1,\n      2)\nend"
  assert_format "begin\n foo(1, \n 2, \n ) \n end", "begin\n  foo(1,\n      2)\nend"
  assert_format "begin\n foo(\n 1, \n 2, \n ) \n end", "begin\n  foo(\n    1,\n    2,\n  )\nend"
  assert_format "begin\n foo(\n 1, \n 2, ) \n end", "begin\n  foo(\n    1,\n    2,\n  )\nend"
  assert_format "begin\n foo(\n1, \n 2) \n end", "begin\n  foo(\n    1,\n    2\n  )\nend"
  assert_format "begin\n foo(\n1, \n 2 # comment\n) \n end", "begin\n  foo(\n    1,\n    2 # comment\n  )\nend"
  assert_format "foo(bar(\n1,\n))", "foo(bar(\n  1,\n))"
  assert_format "foo(bar(\n  1,\n  baz(\n    2\n  )\n))", "foo(bar(\n  1,\n  baz(\n    2\n  )\n))"
  assert_format "foo &block", "foo &block"
  assert_format "foo 1 ,  &block", "foo 1,  &block"
  assert_format "foo(1 ,  &block)", "foo(1,  &block)"
  assert_format "x y z"
  assert_format "x y z w, q"
  assert_format "x(*y, &z)"
  assert_format "foo \\\n 1, 2", "foo \\\n  1, 2"
  assert_format "a(\n*b)", "a(\n  *b\n)"
  assert_format "foo(\nx: 1,\n y: 2\n)", "foo(\n  x: 1,\n  y: 2\n)"
  assert_format "foo bar(\n  1,\n)"
  assert_format "foo 1, {\n  x: y,\n}"
  assert_format "foo 1, [\n  1,\n]"
  assert_format "foo 1, [\n  <<-EOF,\n  bar\nEOF\n]"
  assert_format "foo bar( # foo\n  1, # bar\n)"
  assert_format "foo bar {\n  1\n}"
  assert_format "foo x:  1"
  assert_format "foo(\n  &block\n)"
  assert_format "foo(\n  1,\n  &block\n)"
  assert_format "foo(& block)", "foo(&block)"

  assert_format "foo 1, [\n      2,\n    ]"
  assert_format "foo 1, [\n  2,\n]"
  assert_format "foo bar(\n  2\n)"
  assert_format "foo bar(\n      2\n    )"
  assert_format "foo bar {\n  2\n}"
  assert_format "foo bar {\n      2\n    }"

  assert_format "foobar 1,\n  2"
  assert_format "begin\n  foobar 1,\n    2\nend"

  assert_format "foo([\n      1,\n    ])"
  assert_format "begin\n  foo([\n        1,\n      ])\nend"

  assert_format %(foobar 1,\n  "foo\n   bar")

  # Calls with receiver
  assert_format "foo . bar"
  assert_format "foo:: bar"
  if VERSION >= Gem::Version.new("2.3")
    assert_format "foo&. bar"
  end
  assert_format "foo . bar . baz"
  assert_format "foo . bar( 1 , 2 )", "foo . bar(1, 2)"
  assert_format "foo . \n bar", "foo .\n  bar"
  assert_format "foo . \n bar . \n baz", "foo .\n  bar .\n  baz"
  assert_format "foo \n . bar", "foo\n  . bar"
  assert_format "foo \n . bar \n . baz", "foo\n  . bar\n  . baz"
  assert_format "foo.bar\n.baz", "foo.bar\n  .baz"
  assert_format "foo.bar(1)\n.baz(2)\n.qux(3)", "foo.bar(1)\n  .baz(2)\n  .qux(3)"
  assert_format "foobar.baz\n.with(\n1\n)", "foobar.baz\n  .with(\n    1\n  )"
  assert_format "foo.bar 1, \n x: 1, \n y: 2", "foo.bar 1,\n        x: 1,\n        y: 2"
  assert_format "foo\n  .bar # x\n  .baz"
  assert_format "c.x w 1"
  assert_format "foo.bar\n  .baz\n  .baz"
  assert_format "foo.bar\n  .baz\n   .baz", "foo.bar\n  .baz\n  .baz"
  assert_format "foo.bar(1)\n   .baz([\n  2,\n])", "foo.bar(1)\n   .baz([\n     2,\n   ])"
  assert_format "foo.bar(1)\n   .baz(\n  2,\n)", "foo.bar(1)\n   .baz(\n     2,\n   )"
  assert_format "foo.bar(1)\n   .baz(\n  qux(\n2\n)\n)", "foo.bar(1)\n   .baz(\n     qux(\n       2\n     )\n   )"
  assert_format "foo.bar(1)\n   .baz(\n  qux.last(\n2\n)\n)", "foo.bar(1)\n   .baz(\n     qux.last(\n       2\n     )\n   )"
  assert_format "foo.bar(\n1\n)", "foo.bar(\n  1\n)"
  assert_format "foo 1, [\n  2,\n\n  3,\n]"
  assert_format "foo :x, {\n  :foo1 => :bar,\n\n  :foo2 => bar,\n}\n\nmultiline :call,\n          :foo => :bar,\n          :foo => bar"
  assert_format "x\n  .foo.bar\n  .baz"
  assert_format "x\n  .foo.bar.baz\n  .qux"
  assert_format "x\n  .foo(a.b).bar(c.d).baz(e.f)\n  .qux.z(a.b)\n  .final"
  assert_format "x.y  1,  2"
  assert_format "x.y \\\n  1,  2"

  # Call with dot
  assert_format "foo.()"
  assert_format "foo.( 1 )", "foo.(1)"
  assert_format "foo.( 1, 2 )", "foo.(1, 2)"
  assert_format "x.foo.( 1, 2 )", "x.foo.(1, 2)"

  # Blocks
  assert_format "foo   {}"
  assert_format "foo   {   }", "foo   { }"
  assert_format "foo   {  1 }", "foo   { 1 }"
  assert_format "foo   {  1 ; 2 }", "foo   { 1; 2 }"
  assert_format "foo   {  1 \n 2 }", "foo   {\n  1\n  2\n}"
  assert_format "foo { \n  1 }", "foo {\n  1\n}"
  assert_format "begin \n foo {  1  } \n end", "begin\n  foo { 1 }\nend"
  assert_format "foo { | x , y | }", "foo { |x, y| }"
  assert_format "foo { | x , | }", "foo { |x, | }"
  assert_format "foo { | x , y, | bar}", "foo { |x, y, | bar}"
  assert_format "foo { || }", "foo { }"
  assert_format "foo { | | }", "foo { }"
  assert_format "foo { | ( x ) , z | }", "foo { |(x), z| }"
  assert_format "foo { | ( x , y ) , z | }", "foo { |(x, y), z| }"
  assert_format "foo { | ( x , ( y , w ) ) , z | }", "foo { |(x, (y, w)), z| }"
  assert_format "foo { | bar: 1 , baz: 2 | }", "foo { |bar: 1, baz: 2| }"
  assert_format "foo { | *z | }", "foo { |*z| }"
  assert_format "foo { | **z | }", "foo { |**z| }"
  assert_format "foo { | bar = 1 | }", "foo { |bar = 1| }"
  assert_format "foo { | x , y | 1 }", "foo { |x, y| 1 }"
  assert_format "foo { | x | \n  1 }", "foo { |x|\n  1\n}"
  assert_format "foo { | x , \n y | \n  1 }", "foo { |x,\n       y|\n  1\n}"
  assert_format "foo   do   end", "foo do end"
  assert_format "foo   do 1  end", "foo do 1 end"
  assert_format "bar foo { \n 1 \n }, 2", "bar foo {\n  1\n}, 2"
  assert_format "bar foo { \n 1 \n } + 2", "bar foo {\n  1\n} + 2"
  assert_format "foo { |;x| }", "foo { |; x| }"
  assert_format "foo { |\n;x| }", "foo { |; x| }"
  assert_format "foo { |;x, y| }", "foo { |; x, y| }"
  assert_format "foo { |a, b;x, y| }", "foo { |a, b; x, y| }"
  assert_format "proc { |(x, *y),z| }", "proc { |(x, *y), z| }"
  assert_format "proc { |(w, *x, y), z| }"
  assert_format "foo { |(*x , y), z| }"
  assert_format "foo { begin; end; }", "foo { begin; end }"
  assert_format "foo {\n |i| }", "foo {\n  |i| }\n"

  # Calls with receiver and block
  assert_format "foo.bar 1 do \n end", "foo.bar 1 do\nend"
  assert_format "foo::bar 1 do \n end", "foo::bar 1 do\nend"
  if VERSION >= Gem::Version.new("2.3")
    assert_format "foo&.bar 1 do \n end", "foo&.bar 1 do\nend"
  end
  assert_format "foo.bar baz, 2 do \n end", "foo.bar baz, 2 do\nend"

  # Super
  assert_format "super"
  assert_format "super 1"
  assert_format "super 1, \n 2", "super 1,\n      2"
  assert_format "super( 1 )", "super(1)"
  assert_format "super( 1 , 2 )", "super(1, 2)"

  # Return
  assert_format "return"
  assert_format "return  1", "return 1"
  assert_format "return  1 , 2", "return 1, 2"
  assert_format "return  1 , \n 2", "return 1,\n       2"
  assert_format "return a b"

  # Break
  assert_format "break"
  assert_format "break  1", "break 1"
  assert_format "break  1 , 2", "break 1, 2"
  assert_format "break  1 , \n 2", "break 1,\n      2"

  # Next
  assert_format "next"
  assert_format "next  1", "next 1"
  assert_format "next  1 , 2", "next 1, 2"
  assert_format "next  1 , \n 2", "next 1,\n     2"

  # Yield
  assert_format "yield"
  assert_format "yield  1", "yield 1"
  assert_format "yield  1 , 2", "yield 1, 2"
  assert_format "yield  1 , \n 2", "yield 1,\n      2"
  assert_format "yield( 1 , 2 )", "yield(1, 2)"

  # Array access
  assert_format "foo[ ]", "foo[]"
  assert_format "foo[ \n ]", "foo[]"
  assert_format "foo[ 1 ]", "foo[1]"
  assert_format "foo[ 1 , 2 , 3 ]", "foo[1, 2, 3]"
  assert_format "foo[ 1 , \n 2 , \n 3 ]", "foo[1,\n    2,\n    3]"
  assert_format "foo[ \n 1 , \n 2 , \n 3 ]", "foo[\n  1,\n  2,\n  3]"
  assert_format "foo[ *x ]", "foo[*x]"
  assert_format "foo[\n 1, \n]", "foo[\n  1,\n]"
  assert_format "foo[\n 1, \n 2 , 3, \n 4, \n]", "foo[\n  1,\n  2, 3,\n  4,\n]"

  # Array setter
  assert_format "foo[ ]  =  1", "foo[]  =  1"
  assert_format "foo[ 1 , 2 ]  =  3", "foo[1, 2]  =  3"

  # Property setter
  assert_format "foo . bar  =  1"
  assert_format "foo . bar  = \n 1", "foo . bar  =\n  1"
  assert_format "foo . \n bar  = \n 1", "foo .\n  bar  =\n  1"
  assert_format "foo:: bar  =  1"
  assert_format "foo:: bar  = \n 1", "foo:: bar  =\n  1"
  assert_format "foo:: \n bar  = \n 1", "foo::\n  bar  =\n  1"
  if VERSION >= Gem::Version.new("2.3")
    assert_format "foo&. bar  =  1"
  end

  # Range
  assert_format "1 .. 2", "1..2"
  assert_format "1 ... 2", "1...2"

  # Regex
  assert_format "//"
  assert_format "//ix"
  assert_format "/foo/"
  assert_format "/foo \#{1 + 2} /"
  assert_format "%r( foo )"

  # Unary operators
  assert_format "- x"
  assert_format "+ x"
  assert_format "+x"
  assert_format "+(x)"
  assert_format "+ (x)"

  # Binary operators
  assert_format "1   +   2"
  assert_format "1+2"
  assert_format "1   +  \n 2", "1   +\n  2"
  assert_format "1   +  # hello \n 2", "1   + # hello\n  2"
  assert_format "1 +\n 2+\n 3", "1 +\n  2+\n  3"
  assert_format "1  &&  2"
  assert_format "1  ||  2"
  assert_format "1*2"
  assert_format "1* 2"
  assert_format "1 *2"
  assert_format "1/2", "1/2"
  assert_format "1**2", "1**2"
  assert_format "1 \\\n + 2", "1 \\\n  + 2"
  assert_format "a = 1 ||\n2", "a = 1 ||\n    2"
  assert_format "1 ||\n2"

  # And/Or/Not
  assert_format " foo  and  bar ", "foo  and  bar"
  assert_format " foo  or  bar ", "foo  or  bar"
  assert_format " not  foo", "not  foo"
  assert_format "not(x)"
  assert_format "not (x)"
  assert_format "not((a, b = 1, 2))"

  # Class
  assert_format "class   Foo  \n  end", "class Foo\nend"
  assert_format "class   Foo  < Bar \n  end", "class Foo < Bar\nend"
  assert_format "class Foo\n1\nend", "class Foo\n  1\nend"
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
  assert_format "begin\n 1 ; 2 \n end", "begin\n  1; 2\nend"

  # begin/end
  assert_format "begin;end", "begin; end"
  assert_format "begin \n end", "begin\nend"
  assert_format "begin 1 end", "begin 1 end"
  assert_format "begin; 1; end", "begin; 1; end"
  assert_format "begin; 1; 2; end", "begin; 1; 2; end"
  assert_format "begin; 1 \n 2; end", "begin; 1\n  2; end"
  assert_format "begin\n 1 \n end", "begin\n  1\nend"
  assert_format "begin\n 1 \n 2 \n end", "begin\n  1\n  2\nend"
  assert_format "begin \n begin \n 1 \n end \n 2 \n end", "begin\n  begin\n    1\n  end\n  2\nend"
  assert_format "begin # hello\n end", "begin # hello\nend"
  assert_format "begin;# hello\n end", "begin # hello\nend"
  assert_format "begin\n 1  # a\nend", "begin\n  1 # a\nend"
  assert_format "begin\n 1  # a\n # b \n 3 # c \n end", "begin\n  1 # a\n  # b\n  3 # c\nend"
  assert_format "begin\nend\n\n# foo"
  assert_format "begin\n  begin 1 end\nend"
  assert_format "begin\n  def foo(x) 1 end\nend"
  assert_format "begin\n  if 1 then 2 end\nend"
  assert_format "begin\n  if 1 then 2 end\nend"
  assert_format "begin\n  foo do 1 end\nend"
  assert_format "begin\n  for x in y do 1 end\nend"
  assert_format "begin\n  # foo\n\n  1\nend"

  # begin/rescue/end
  assert_format "begin \n 1 \n rescue \n 2 \n end", "begin\n  1\nrescue\n  2\nend"
  assert_format "begin\nrescue A\nrescue B\nend"
  assert_format "begin \n 1 \n rescue   Foo \n 2 \n end", "begin\n  1\nrescue Foo\n  2\nend"
  assert_format "begin \n 1 \n rescue  =>   ex  \n 2 \n end", "begin\n  1\nrescue => ex\n  2\nend"
  assert_format "begin \n 1 \n rescue  Foo  =>  ex \n 2 \n end", "begin\n  1\nrescue Foo => ex\n  2\nend"
  assert_format "begin \n 1 \n rescue  Foo  , Bar , Baz =>  ex \n 2 \n end", "begin\n  1\nrescue Foo, Bar, Baz => ex\n  2\nend"
  assert_format "begin \n 1 \n rescue  Foo  , \n Bar , \n Baz =>  ex \n 2 \n end", "begin\n  1\nrescue Foo,\n       Bar,\n       Baz => ex\n  2\nend"
  assert_format "begin \n 1 \n ensure \n 2 \n end", "begin\n  1\nensure\n  2\nend"
  assert_format "begin \n 1 \n else \n 2 \n end", "begin\n  1\nelse\n  2\nend"
  assert_format "begin\n  1\nrescue *x\nend"
  assert_format "begin\n  1\nrescue *x, *y\nend"
  assert_format "begin\n  1\nrescue *x, y, *z\nend"

  # Parentheses
  assert_format "  ( 1 ) ", "(1)"
  assert_format "  ( 1 ; 2 ) ", "(1; 2)"

  # Method definition
  assert_format "  def   foo \n end", "def foo\nend"
  assert_format "  def   foo ; end", "def foo; end"
  assert_format "  def   foo() \n end", "def foo\nend"
  assert_format "  def   foo() 1 end", "def foo() 1 end"
  assert_format "  def   foo ( \n ) \n end", "def foo\nend"
  assert_format "  def   foo ( x ) \n end", "def foo(x)\nend"
  assert_format "  def   foo ( x , y ) \n end", "def foo(x, y)\nend"
  assert_format "  def   foo x \n end", "def foo x\nend"
  assert_format "  def   foo x , y \n end", "def foo x, y\nend"
  assert_format "  def   foo \n 1 \n end", "def foo\n  1\nend"
  assert_format "  def   foo( * x ) \n 1 \n end", "def foo(*x)\n  1\nend"
  assert_format "  def   foo( a , * x ) \n 1 \n end", "def foo(a, *x)\n  1\nend"
  assert_format "  def   foo( a , * x, b ) \n 1 \n end", "def foo(a, *x, b)\n  1\nend"
  assert_format "  def   foo ( x  =  1 ) \n end", "def foo(x = 1)\nend"
  assert_format "  def   foo ( x  =  1, * y ) \n end", "def foo(x = 1, *y)\nend"
  assert_format "  def   foo ( & block ) \n end", "def foo(&block)\nend"
  assert_format "  def   foo ( a: , b: ) \n end", "def foo(a:, b:)\nend"
  assert_format "  def   foo ( a: 1 , b: 2  ) \n end", "def foo(a: 1, b: 2)\nend"
  assert_format "  def   foo ( x, \n y ) \n end", "def foo(x,\n        y)\nend"
  assert_format "  def   foo ( a: 1, \n b: 2 ) \n end", "def foo(a: 1,\n        b: 2)\nend"
  assert_format "  def   foo (\n x, \n y ) \n end", "def foo(\n        x,\n        y)\nend"
  assert_format "  def   foo ( a: 1, &block ) \n end", "def foo(a: 1, &block)\nend"
  assert_format "  def   foo ( a: 1, \n &block ) \n end", "def foo(a: 1,\n        &block)\nend"
  assert_format "  def foo(*) \n end", "def foo(*)\nend"
  assert_format "  def foo(**) \n end", "def foo(**)\nend"
  assert_format "def `(cmd)\nend"
  assert_format "module_function def foo\n  1\nend"
  assert_format "private def foo\n  1\nend"
  assert_format "some class Foo\n  1\nend"

  # Method definition with receiver
  assert_format " def foo . \n bar; end", "def foo.bar; end"
  assert_format " def self . \n bar; end", "def self.bar; end"

  # Array literal
  assert_format " [  ] ", "[]"
  assert_format " [  1 ] ", "[ 1 ]"
  assert_format " [  1 , 2 ] ", "[ 1, 2 ]"
  assert_format " [  1 , 2 , ] ", "[ 1, 2 ]"
  assert_format " [ \n 1 , 2 ] ", "[\n  1, 2\n]"
  assert_format " [ \n 1 , 2, ] ", "[\n  1, 2,\n]"
  assert_format " [ \n 1 , 2 , \n 3 , 4 ] ", "[\n  1, 2,\n  3, 4\n]"
  assert_format " [ \n 1 , \n 2] ", "[\n  1,\n  2\n]"
  assert_format " [  # comment \n 1 , \n 2] ", "[ # comment\n  1,\n  2\n]"
  assert_format " [ \n 1 ,  # comment  \n 2] ", "[\n  1, # comment\n  2\n]"
  assert_format " [  1 , \n 2, 3, \n 4 ] ", "[ 1,\n  2, 3,\n  4 ]"
  assert_format " [  1 , \n 2, 3, \n 4, ] ", "[ 1,\n  2, 3,\n  4 ]"
  assert_format " [  1 , \n 2, 3, \n 4,\n ] ", "[ 1,\n  2, 3,\n  4 ]"
  assert_format " [  1 , \n 2, 3, \n 4, # foo \n ] ", "[ 1,\n  2, 3,\n  4 # foo\n]"
  assert_format " begin\n [ \n 1 , 2 ] \n end ", "begin\n  [\n    1, 2\n  ]\nend"
  assert_format " [ \n 1 # foo\n ]", "[\n  1 # foo\n]"
  assert_format " [ *x ] ", "[*x]"
  assert_format " [ *x , 1 ] ", "[*x, 1]"
  assert_format " [ 1, *x ] ", "[1, *x]"
  assert_format " x = [{\n foo: 1\n}]", "x = [{\n  foo: 1\n}]"
  assert_format "[1,   2]"

  # Array literal with %w
  assert_format " %w(  ) ", "%w()"
  assert_format " %w(one) ", "%w(one)"
  assert_format " %w( one ) ", "%w( one )"
  assert_format " %w(one   two \n three ) ", "%w(one two\n   three)"
  assert_format " %w( one   two \n three ) ", "%w( one two\n    three )"
  assert_format " %w( \n one ) ", "%w(\n  one)"
  assert_format " %w( \n one \n ) ", "%w(\n  one\n)"
  assert_format " %w[ one ] ", "%w[ one ]"
  assert_format " begin \n %w( \n one \n ) \n end", "begin\n  %w(\n    one\n  )\nend"

  # Array literal with %i
  assert_format " %i(  ) ", "%i()"
  assert_format " %i( one ) ", "%i( one )"
  assert_format " %i( one   two \n three ) ", "%i( one two\n    three )"
  assert_format " %i[ one ] ", "%i[ one ]"

  # Array literal with %W
  assert_format " %W( ) ", "%W()"
  assert_format " %W( one ) ", "%W( one )"
  assert_format " %W( one  two ) ", "%W( one two )"
  assert_format " %W( one  two \#{ 1 } ) ", "%W( one two \#{1} )"
  assert_format "%W(\#{1}2)"

  # Array literal with %I
  assert_format " %I( ) ", "%I()"
  assert_format " %I( one  two \#{ 1 } ) ", "%I( one two \#{1} )"

  # Hash literal
  assert_format " { }", "{}"
  assert_format " {:foo   =>   1 }", "{:foo   =>   1}"
  assert_format " {:foo   =>   1}", "{:foo   =>   1}"
  assert_format " { :foo   =>   1 }", "{ :foo   =>   1 }"
  assert_format " { :foo   =>   1 , 2  =>  3  }", "{ :foo   =>   1, 2  =>  3 }"
  assert_format " { \n :foo   =>   1 ,\n 2  =>  3  }", "{\n  :foo   =>   1,\n  2  =>  3\n}"
  assert_format " { **x }", "{ **x }"
  assert_format " {foo:  1}", "{foo:  1}"
  assert_format " { foo:  1 }", "{ foo:  1 }"
  assert_format " { :foo   => \n  1 }", "{ :foo   => 1 }"
  assert_format %( { "foo": 1 } ), %({ "foo": 1 })
  assert_format %( { "foo \#{ 2 }": 1 } ), %({ "foo \#{2}": 1 })
  assert_format %( { :"one two"  => 3 } ), %({ :"one two"  => 3 })
  assert_format " { foo:  1, \n bar: 2 }", "{ foo:  1,\n  bar: 2 }"
  assert_format "{foo: 1,  bar: 2}"
  assert_format "{1 =>\n   2}", "{1 =>   2}"

  # Lambdas
  assert_format "-> { } ", "-> { }"
  assert_format "->{ } ", "->{ }"
  assert_format "->{   1   } ", "->{ 1 }"
  assert_format "->{   1 ; 2  } ", "->{ 1; 2 }"
  assert_format "->{   1 \n 2  } ", "->{\n  1\n  2\n}"
  assert_format "-> do  1 \n 2  end ", "-> do\n  1\n  2\nend"
  assert_format "->do  1 \n 2  end ", "->do\n  1\n  2\nend"
  assert_format "->( x ){ } ", "->(x) { }"

  # class << self
  assert_format "class  <<  self \n 1 \n end", "class << self\n  1\nend"

  # defined?
  assert_format "defined?  1"
  assert_format "defined? ( 1 )", "defined? (1)"
  assert_format "defined?(1)"
  assert_format "defined?((a, b = 1, 2))"

  # alias
  assert_format "alias  foo  bar", "alias foo bar"
  assert_format "alias  :foo  :bar", "alias :foo :bar"
  assert_format "alias  store  []=", "alias store []="
  assert_format "alias  $foo  $bar", "alias $foo $bar"

  # undef
  assert_format "undef  foo", "undef foo"
  assert_format "undef  foo , bar", "undef foo, bar"

  # Global variable
  assert_format "$abc"
  assert_format "$abc . d"

  # Class variable
  assert_format "@@foo"

  # Regex global vars
  assert_format "$~"
  assert_format "$1"

  # Special global vars
  assert_format "$!"
  assert_format "$@"

  if VERSION >= Gem::Version.new("2.3")
    # Lonely
    assert_format "foo &. bar"
  end

  # retry
  assert_format "retry"

  # redo
  assert_format "redo"

  # for
  assert_format "for  x  in  y\n 2 \n end", "for x in y\n  2\nend"
  assert_format "for  x , y  in  z\n 2 \n end", "for x, y in z\n  2\nend"
  assert_format "for  x  in  y  do\n 2 \n end", "for x in y\n  2\nend"

  # __END__
  assert_format "1\n\n__END__\nthis \n is \n still \n here"
  assert_format "__END__\nno more"

  # BEGIN
  assert_format "BEGIN  { \n 1 \n 2 \n } ", "BEGIN {\n  1\n  2\n}"
  assert_format "BEGIN  { 1 ; 2 } ", "BEGIN { 1; 2 }"

  # END
  assert_format "END  { \n 1 \n 2 \n } ", "END {\n  1\n  2\n}"
  assert_format "END  { 1 ; 2 } ", "END { 1; 2 }"

  # Multiple classes, modules and methods are separated with two lines
  assert_format "def foo\nend\ndef bar\nend", "def foo\nend\n\ndef bar\nend"
  assert_format "class Foo\nend\nclass Bar\nend", "class Foo\nend\n\nclass Bar\nend"
  assert_format "module Foo\nend\nmodule Bar\nend", "module Foo\nend\n\nmodule Bar\nend"
  assert_format "1\ndef foo\nend", "1\n\ndef foo\nend"

  # private/protected/public must are separated with two lines
  ["private", "protected", "public"].each do |keyword|
    assert_format "#{keyword}\nattr_reader :foo", "#{keyword}\n\nattr_reader :foo"
    assert_format "attr_reader :foo\n#{keyword}", "attr_reader :foo\n\n#{keyword}"
  end

  assert_format "def meth(fallback:       nil)\nend", "def meth(fallback: nil)\nend"

  assert_format "private\n# comment\n1", "private\n\n# comment\n1"

  # Align successive comments
  assert_format "1 # one \n 123 # two", "1   # one\n123 # two", align_comments: true
  assert_format "1 # one \n 123 # two \n 4 \n 5 # lala", "1   # one\n123 # two\n4\n5 # lala", align_comments: true
  assert_format "foobar( # one \n 1 # two \n)", "foobar( # one\n  1     # two\n)", align_comments: true
  assert_format "a = 1 # foo\n abc = 2 # bar", "a   = 1 # foo\nabc = 2 # bar", align_assignments: true, align_comments: true
  assert_format "a = 1 # foo\n      # bar", align_comments: true
  assert_format "# foo\na # bar", align_comments: true
  assert_format " # foo\na # bar", "# foo\na # bar", align_comments: true
  assert_format "require x\n\n# Comment 1\n# Comment 2\nFOO = :bar # Comment 3", align_comments: true
  assert_format "begin\n  require x\n\n  # Comment 1\n  # Comment 2\n  FOO = :bar # Comment 3\nend", align_comments: true
  assert_format "begin\n  a     # c1\n        # c2\n  b = 1 # c3\nend", align_comments: true

  # Align successive assignments
  assert_format "x = 1 \n xyz = 2\n\n w = 3", "x   = 1\nxyz = 2\n\nw = 3", align_assignments: true
  assert_format "x = 1 \n foo[bar] = 2\n\n w = 3", "x        = 1\nfoo[bar] = 2\n\nw = 3", align_assignments: true
  assert_format "x = 1; x = 2 \n xyz = 2\n\n w = 3", "x   = 1; x = 2\nxyz = 2\n\nw = 3", align_assignments: true
  assert_format "a = begin\n b = 1 \n abc = 2 \n end", "a = begin\n  b   = 1\n  abc = 2\nend", align_assignments: true
  assert_format "a = 1\n a += 2", "a  = 1\na += 2", align_assignments: true
  assert_format "foo = 1\n a += 2", "foo = 1\na  += 2", align_assignments: true

  # Align successive hash keys
  assert_format "{ \n 1 => 2, \n 123 => 4 }", "{\n  1   => 2,\n  123 => 4\n}", align_hash_keys: true
  assert_format "{ \n foo: 1, \n barbaz: 2 }", "{\n  foo:    1,\n  barbaz: 2\n}", align_hash_keys: true
  assert_format "foo bar: 1, \n barbaz: 2", "foo bar:    1,\n    barbaz: 2", align_hash_keys: true
  assert_format "foo(\n  bar: 1, \n barbaz: 2)", "foo(\n  bar:    1,\n  barbaz: 2\n)", align_hash_keys: true
  assert_format "def foo(x, \n y: 1, \n bar: 2)\nend", "def foo(x,\n        y:   1,\n        bar: 2)\nend", align_hash_keys: true
  assert_format "{1 => 2}\n{123 => 4}", align_hash_keys: true
  assert_format "{\n 1 => 2, \n 345 => { \n  4 => 5 \n } \n }", "{\n  1 => 2,\n  345 => {\n    4 => 5\n  }\n}", align_hash_keys: true
  assert_format "{\n 1 => 2, \n 345 => { # foo \n  4 => 5 \n } \n }", "{\n  1 => 2,\n  345 => { # foo\n    4 => 5\n  }\n}", align_hash_keys: true
  assert_format "{\n 1 => 2, \n 345 => [ \n  4 \n ] \n }", "{\n  1 => 2,\n  345 => [\n    4\n  ]\n}", align_hash_keys: true
  assert_format "{\n 1 => 2, \n foo: [ \n  4 \n ] \n }", "{\n  1 => 2,\n  foo: [\n    4\n  ]\n}", align_hash_keys: true
  assert_format "foo 1, bar: [\n         2,\n       ],\n       baz: 3", align_hash_keys: true
  assert_format "a   = b :foo => x,\n  :baar => x", "a   = b :foo  => x,\n        :baar => x", align_hash_keys: true
  assert_format " {:foo   =>   1 }", "{:foo   => 1}", align_hash_keys: true
  assert_format " {:foo   =>   1}", "{:foo   => 1}", align_hash_keys: true
  assert_format " { :foo   =>   1 }", "{ :foo   => 1 }", align_hash_keys: true
  assert_format " { :foo   =>   1 , 2  =>  3  }", "{ :foo   => 1, 2  => 3 }", align_hash_keys: true
  assert_format " { \n :foo   =>   1 ,\n 2  =>  3  }", "{\n  :foo   => 1,\n  2      => 3\n}", align_hash_keys: true
  assert_format " { foo:  1, \n bar: 2 }", "{ foo:  1,\n  bar:  2 }", align_hash_keys: true

  # Align successive case when
  assert_format "case\n when 1 then 2\n when 234 then 5 \n end", "case\nwhen 1   then 2\nwhen 234 then 5\nend", align_case_when: true
  assert_format "case\n when 1; 2\n when 234; 5 \n end", "case\nwhen 1;   2\nwhen 234; 5\nend", align_case_when: true

  # Align mix
  assert_format "abc = 1\na = {foo: 1, # comment\n bar: 2} # another", "abc = 1\na   = {foo: 1, # comment\n       bar: 2} # another", align_assignments: true, align_hash_keys: true, align_comments: true
  assert_format "abc = 1\na = {foobar: 1, # comment\n bar: 2} # another", "abc = 1\na   = {foobar: 1, # comment\n       bar:    2} # another", align_assignments: true, align_hash_keys: true, align_comments: true

  # Settings

  # indent_size
  assert_format "begin \n 1 \n end", "begin\n    1\nend", indent_size: 4

  # align_comments
  assert_format "1 # one\n 123 # two", "1 # one\n123 # two", align_comments: false
  assert_format "foo bar( # foo\n  1,     # bar\n)", align_comments: true

  # align_assignments
  assert_format "x = 1 \n xyz = 2\n\n w = 3", "x = 1\nxyz = 2\n\nw = 3", align_assignments: false

  # align_hash_keys
  assert_format "foo 1,  :bar  =>  2 , :baz  =>  3", "foo 1,  :bar  => 2, :baz  => 3", align_hash_keys: true
  assert_format "{ \n foo: 1, \n barbaz: 2 }", "{\n  foo:    1,\n  barbaz: 2\n}", align_hash_keys: true

  # align_case_when
  assert_format "case\n when 1 then 2\n when 234 then 5 \n end", "case\nwhen 1 then 2\nwhen 234 then 5\nend", align_case_when: false

  # spaces_inside_hash_brace
  assert_format "{ 1 => 2 }", "{1 => 2}", spaces_inside_hash_brace: :never
  assert_format "{1 => 2}", "{ 1 => 2 }", spaces_inside_hash_brace: :always

  # spaces_inside_array_bracket
  assert_format "[ 1 ]", "[1]", spaces_inside_array_bracket: :never
  assert_format "[1]", "[ 1 ]", spaces_inside_array_bracket: :always
  assert_format "[1]", "[1]", spaces_inside_array_bracket: :dynamic
  assert_format "[ 1]", "[ 1 ]", spaces_inside_array_bracket: :dynamic

  # spaces_around_equal
  assert_format "a=1", "a = 1", spaces_around_equal: :one
  assert_format "a  =  1", "a = 1", spaces_around_equal: :one
  assert_format "a  =  1", "a = 1", spaces_around_equal: :dynamic, align_assignments: true
  assert_format "a  =  1", "a = 1", spaces_around_equal: :one, align_assignments: true

  assert_format "a+=1", "a += 1", spaces_around_equal: :one
  assert_format "a  +=  1", "a += 1", spaces_around_equal: :one
  assert_format "a  +=  1", "a += 1", spaces_around_equal: :dynamic, align_assignments: true
  assert_format "a  +=  1", "a += 1", spaces_around_equal: :one, align_assignments: true

  # spaces_in_ternary
  assert_format "1?2:3", "1 ? 2 : 3", spaces_in_ternary: :one
  assert_format "1  ?  2  :  3", "1  ?  2  :  3", spaces_in_ternary: :dynamic

  # spaces_in_commands
  assert_format "foo  1", "foo 1", spaces_in_commands: :one
  assert_format "foo.bar  1", "foo.bar 1", spaces_in_commands: :one

  assert_format "not x", "not x", spaces_in_commands: :dynamic
  assert_format "not  x", "not  x", spaces_in_commands: :dynamic
  assert_format "not x", "not x", spaces_in_commands: :one
  assert_format "not  x", "not x", spaces_in_commands: :one

  assert_format "defined? 1", "defined? 1", spaces_in_commands: :dynamic
  assert_format "defined?  1", "defined?  1", spaces_in_commands: :dynamic
  assert_format "defined?  1", "defined? 1", spaces_in_commands: :one

  # spaces_in_suffix
  assert_format "1  if  2", "1 if 2", spaces_in_suffix: :one

  # spaces_around_block_brace
  assert_format "foo{1}", "foo { 1 }", spaces_around_block_brace: :one
  assert_format "foo{|x|1}", "foo { |x| 1 }", spaces_around_block_brace: :one
  assert_format "foo{1}", "foo{1}", spaces_around_block_brace: :dynamic
  assert_format "foo{|x|1}", "foo{|x|1}", spaces_around_block_brace: :dynamic
  assert_format "foo  {  1  }", "foo { 1 }", spaces_around_block_brace: :one
  assert_format "foo  {  1  }", "foo  { 1 }", spaces_around_block_brace: :dynamic
  assert_format "->{1}", "->{1}", spaces_around_block_brace: :dynamic
  assert_format "->{1}", "->{ 1 }", spaces_around_block_brace: :one

  # spaces_after_comma
  assert_format "foo 1,  2,  3", "foo 1, 2, 3", spaces_after_comma: :one
  assert_format "foo 1,  2,  3", "foo 1,  2,  3", spaces_after_comma: :dynamic

  assert_format "foo(1,  2,  3)", "foo(1, 2, 3)", spaces_after_comma: :one
  assert_format "foo(1,  2,  3)", "foo(1,  2,  3)", spaces_after_comma: :dynamic

  assert_format "[1,  2,  3]", "[1, 2, 3]", spaces_after_comma: :one
  assert_format "[1,  2,  3]", "[1,  2,  3]", spaces_after_comma: :dynamic

  assert_format "a  ,  b = 1,  2", "a, b = 1, 2", spaces_after_comma: :one
  assert_format "a  ,  b = 1,  2", "a,  b = 1,  2", spaces_after_comma: :dynamic

  # spaces_around_hash_arrow
  assert_format "{1  =>  2}", "{1 => 2}", spaces_around_hash_arrow: :one
  assert_format "{1  =>  2}", "{1  =>  2}", spaces_around_hash_arrow: :dynamic

  assert_format "{1=>2}", "{1 => 2}", spaces_around_hash_arrow: :one
  assert_format "{1=>2}", "{1=>2}", spaces_around_hash_arrow: :dynamic

  assert_format "{foo:  2}", "{foo: 2}", spaces_around_hash_arrow: :one
  assert_format "{foo:  2}", "{foo:  2}", spaces_around_hash_arrow: :dynamic

  assert_format "{foo:2}", "{foo: 2}", spaces_around_hash_arrow: :one
  assert_format "{foo:2}", "{foo:2}", spaces_around_hash_arrow: :dynamic

  # spaces_around_when
  assert_format "case 1\nwhen  2  then  3\nend", "case 1\nwhen 2 then 3\nend", spaces_around_when: :one
  assert_format "case 1\nwhen  2  then  3\nend", spaces_around_when: :dynamic

  # spaces_around_dot
  assert_format "foo . bar", "foo . bar", spaces_around_dot: :dynamic
  assert_format "foo . bar = 1", "foo . bar = 1", spaces_around_dot: :dynamic
  assert_format "foo . bar", "foo.bar", spaces_around_dot: :no
  assert_format "foo . bar = 1", "foo.bar = 1", spaces_around_dot: :no

  # spaces_after_lambda_arrow
  assert_format "->  { }", "->  { }", spaces_after_lambda_arrow: :dynamic
  assert_format "->  { }", "->{ }", spaces_after_lambda_arrow: :no

  # spaces_around_unary
  assert_format "- x", "- x", spaces_around_unary: :dynamic
  assert_format "- x", "-x", spaces_around_unary: :no

  # spaces_around_binary
  assert_format "1+2", "1+2", spaces_around_binary: :dynamic
  assert_format "1+2", "1+2", spaces_around_binary: :one

  assert_format "1  +  2", "1  +  2", spaces_around_binary: :dynamic
  assert_format "1  +  2", "1 + 2", spaces_around_binary: :one

  assert_format "1+  2", "1+  2", spaces_around_binary: :dynamic
  assert_format "1 +2", "1 + 2", spaces_around_binary: :one

  # parens_in_def
  assert_format "def foo(x); end", "def foo(x); end", parens_in_def: :dynamic
  assert_format "def foo x; end", "def foo x; end", parens_in_def: :dynamic

  assert_format "def foo(x); end", "def foo(x); end", parens_in_def: :yes
  assert_format "def foo x; end", "def foo(x); end", parens_in_def: :yes

  # double_newline_inside_type
  assert_format "class Foo\n\n1\n\nend", "class Foo\n  1\nend", double_newline_inside_type: :no
  assert_format "class Foo\n\n1\n\nend", "class Foo\n\n  1\n\nend", double_newline_inside_type: :dynamic

  # visibility_indent
  assert_format "private\n\nfoo\nbar", "private\n\nfoo\nbar", visibility_indent: :dynamic
  assert_format "private\n\n  foo\nbar", "private\n\n  foo\n  bar", visibility_indent: :dynamic

  assert_format "private\n\n  foo\nbar", "private\n\nfoo\nbar", visibility_indent: :align
  assert_format "private\n\nfoo\nbar", "private\n\n  foo\n  bar", visibility_indent: :indent

  assert_format "private\n\n  foo\nbar\n\nprotected\n\n  baz", "private\n\n  foo\n  bar\n\nprotected\n\n  baz", visibility_indent: :dynamic
  assert_format "private\n\nfoo\nbar\n\nprotected\n\nbaz", "private\n\n  foo\n  bar\n\nprotected\n\n  baz", visibility_indent: :indent
  assert_format "private\n\n  foo\nbar\n\nprotected\n\n  baz", "private\n\nfoo\nbar\n\nprotected\n\nbaz", visibility_indent: :align

  assert_format "class Foo\n  private\n\n    foo\nend", visibility_indent: :dynamic
  assert_format "class << self\n  private\n\n    foo\nend", visibility_indent: :dynamic

  # trailing_commas
  assert_format "[\n  1,\n  2,\n]", trailing_commas: :dynamic
  assert_format "[\n  1,\n  2,\n]", trailing_commas: :always
  assert_format "[\n  1,\n  2,\n]", "[\n  1,\n  2\n]", trailing_commas: :never

  assert_format "[\n  1,\n  2\n]", trailing_commas: :dynamic
  assert_format "[\n  1,\n  2\n]", "[\n  1,\n  2,\n]", trailing_commas: :always
  assert_format "[\n  1,\n  2\n]", trailing_commas: :never

  assert_format "{\n  foo: 1,\n  bar: 2,\n}", trailing_commas: :dynamic
  assert_format "{\n  foo: 1,\n  bar: 2,\n}", trailing_commas: :always
  assert_format "{\n  foo: 1,\n  bar: 2,\n}", "{\n  foo: 1,\n  bar: 2\n}", trailing_commas: :never

  assert_format "{\n  foo: 1,\n  bar: 2\n}", trailing_commas: :dynamic
  assert_format "{\n  foo: 1,\n  bar: 2\n}", "{\n  foo: 1,\n  bar: 2,\n}", trailing_commas: :always
  assert_format "{\n  foo: 1,\n  bar: 2\n}", trailing_commas: :never

  assert_format "foo(\n  one:   1,\n  two:   2,\n  three: 3,\n)", trailing_commas: :dynamic
  assert_format "foo(\n  one:   1,\n  two:   2,\n  three: 3,\n)", trailing_commas: :always
  assert_format "foo(\n  one:   1,\n  two:   2,\n  three: 3,\n)", "foo(\n  one:   1,\n  two:   2,\n  three: 3\n)", trailing_commas: :never

  assert_format "foo(\n  one:   1,\n  two:   2,\n  three: 3\n)", trailing_commas: :dynamic
  assert_format "foo(\n  one:   1,\n  two:   2,\n  three: 3\n)", "foo(\n  one:   1,\n  two:   2,\n  three: 3,\n)", trailing_commas: :always
  assert_format "foo(\n  one:   1,\n  two:   2,\n  three: 3\n)", trailing_commas: :never

  assert_format "foo(\n  one: 1)", "foo(\n  one: 1\n)", trailing_commas: :dynamic
  assert_format "foo(\n  one: 1)", "foo(\n  one: 1,\n)", trailing_commas: :always
  assert_format "foo(\n  one: 1)", "foo(\n  one: 1\n)", trailing_commas: :never

  assert_format "foo(\n  one: 1,)", "foo(\n  one: 1,\n)", trailing_commas: :dynamic
  assert_format "foo(\n  one: 1,)", "foo(\n  one: 1,\n)", trailing_commas: :always
  assert_format "foo(\n  one: 1,)", "foo(\n  one: 1\n)", trailing_commas: :never

  assert_format " [ \n 1 , 2 ] ", "[\n  1, 2,\n]", trailing_commas: :always
  assert_format " [ \n 1 , 2, ] ", "[\n  1, 2,\n]", trailing_commas: :always
  assert_format " [ \n 1 , 2 , \n 3 , 4 ] ", "[\n  1, 2,\n  3, 4,\n]", trailing_commas: :always
  assert_format " [ \n 1 , \n 2] ", "[\n  1,\n  2,\n]", trailing_commas: :always
  assert_format " [  # comment \n 1 , \n 2] ", "[ # comment\n  1,\n  2,\n]", trailing_commas: :always
  assert_format " [ \n 1 ,  # comment  \n 2] ", "[\n  1, # comment\n  2,\n]", trailing_commas: :always
  assert_format " [  1 , \n 2, 3, \n 4 ] ", "[ 1,\n  2, 3,\n  4 ]", trailing_commas: :always
  assert_format " [  1 , \n 2, 3, \n 4, ] ", "[ 1,\n  2, 3,\n  4 ]", trailing_commas: :always
  assert_format " [  1 , \n 2, 3, \n 4,\n ] ", "[ 1,\n  2, 3,\n  4 ]", trailing_commas: :always
  assert_format " [  1 , \n 2, 3, \n 4, # foo \n ] ", "[ 1,\n  2, 3,\n  4 # foo\n]", trailing_commas: :always
  assert_format " begin\n [ \n 1 , 2 ] \n end ", "begin\n  [\n    1, 2,\n  ]\nend", trailing_commas: :always
  assert_format " [ \n 1 # foo\n ]", "[\n  1, # foo\n]", trailing_commas: :always

  # align chained calls
  assert_format "foo . bar \n . baz", "foo . bar\n    . baz", align_chained_calls: true
  assert_format "foo . bar \n . baz \n . qux", "foo . bar\n    . baz\n    . qux", align_chained_calls: true
  assert_format "foo . bar( x.y ) \n . baz \n . qux", "foo . bar(x.y)\n    . baz\n    . qux", align_chained_calls: true
end
