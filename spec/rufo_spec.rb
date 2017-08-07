require "spec_helper"
require "fileutils"

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
  Dir[File.dirname(__FILE__) + "/source_tests/*.rb"].each do |source_test|
    pp File.read(source_test).split("#~# ORIGINAL")
    # File.foreach(source_test) do |line|
      
    # end
  end
  
=begin
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
  assert_format " {:foo   =>   1 }", "{:foo   => 1 }", align_hash_keys: true
  assert_format " {:foo   =>   1}", "{:foo   => 1}", align_hash_keys: true
  assert_format " { :foo   =>   1 }", "{ :foo   => 1 }", align_hash_keys: true
  assert_format " { :foo   =>   1 , 2  =>  3  }", "{ :foo   => 1, 2  => 3  }", align_hash_keys: true
  assert_format " { \n :foo   =>   1 ,\n 2  =>  3  }", "{\n  :foo   => 1,\n  2      => 3\n}", align_hash_keys: true
  assert_format " { foo:  1, \n bar: 2 }", "{ foo:  1,\n  bar:  2 }", align_hash_keys: true
  assert_format "=begin\n=end\n{\n  :a  => 1,\n  :bc => 2\n}", align_hash_keys: true

  # Align mix
  assert_format "abc = 1\na = {foo: 1, # comment\n bar: 2} # another", "abc = 1\na   = {foo: 1, # comment\n       bar: 2} # another", align_assignments: true, align_hash_keys: true, align_comments: true
  assert_format "abc = 1\na = {foobar: 1, # comment\n bar: 2} # another", "abc = 1\na   = {foobar: 1, # comment\n       bar:    2} # another", align_assignments: true, align_hash_keys: true, align_comments: true

  # Settings

  # indent_size
  assert_format "begin \n 1 \n end", "begin\n    1\nend", indent_size: 4

  # align_comments
  assert_format "1 # one\n 123 # two", "1 # one\n123 # two", align_comments: false
  assert_format "foo bar( # foo\n  1,     # bar\n)", align_comments: true
  assert_format "a = 1   # foo\nbar = 2 # baz", align_comments: false
  assert_format "[\n  1,   # foo\n  234,   # bar\n]", align_comments: false
  assert_format "[\n  1,   # foo\n  234    # bar\n]", align_comments: false
  assert_format "foo bar: 1,  # comment\n    baz: 2    # comment", align_comments: false

  # align_assignments
  assert_format "x = 1 \n xyz = 2\n\n w = 3", "x = 1\nxyz = 2\n\nw = 3", align_assignments: false

  # align_hash_keys
  assert_format "foo 1,  :bar  =>  2 , :baz  =>  3", "foo 1,  :bar  => 2, :baz  => 3", align_hash_keys: true
  assert_format "{ \n foo: 1, \n barbaz: 2 }", "{\n  foo:    1,\n  barbaz: 2\n}", align_hash_keys: true

  # align_case_when
  assert_format "case\n when 1 then 2\n when 234 then 5 \n else 6\n end", "case\nwhen 1   then 2\nwhen 234 then 5\nelse          6\nend", align_case_when: true
  assert_format "case\n when 1; 2\n when 234; 5 \n end", "case\nwhen 1;   2\nwhen 234; 5\nend", align_case_when: true
  assert_format "case\n when 1; 2\n when 234; 5 \n else 6\n end", "case\nwhen 1;   2\nwhen 234; 5\nelse      6\nend", align_case_when: true
  assert_format "case\n when 1 then 2\n when 234 then 5 \n else 6 \n end", "case\nwhen 1 then 2\nwhen 234 then 5\nelse 6\nend", align_case_when: false

  # spaces_inside_hash_brace
  assert_format "{ 1 => 2 }", "{1 => 2}", spaces_inside_hash_brace: :never
  assert_format "{1 => 2}", "{ 1 => 2 }", spaces_inside_hash_brace: :always
  assert_format "{  1 => 2   }", spaces_inside_hash_brace: :dynamic
  assert_format "{1 => 2  }", "{1 => 2}", spaces_inside_hash_brace: :match
  assert_format "{  1 => 2}", "{ 1 => 2 }", spaces_inside_hash_brace: :match
  assert_format "{  1 => 2   }", "{ 1 => 2 }", spaces_inside_hash_brace: :match

  # spaces_inside_array_bracket
  assert_format "[ 1 ]", "[1]", spaces_inside_array_bracket: :never
  assert_format "[1]", "[ 1 ]", spaces_inside_array_bracket: :always
  assert_format "[1]", spaces_inside_array_bracket: :dynamic
  assert_format "[ 1]", spaces_inside_array_bracket: :dynamic
  assert_format "[  1, 2   ]", spaces_inside_array_bracket: :dynamic
  assert_format "[   1, 2]", "[ 1, 2 ]", spaces_inside_array_bracket: :match
  assert_format "[1, 2   ]", "[1, 2]", spaces_inside_array_bracket: :match

  assert_format "a[ 1  ]", spaces_inside_array_bracket: :dynamic

  # spaces_around_equal
  assert_format "a=1", "a = 1", spaces_around_equal: :one
  assert_format "a  =  1", "a = 1", spaces_around_equal: :one
  assert_format "a  =  1", "a = 1", spaces_around_equal: :dynamic, align_assignments: true
  assert_format "a  =  1", "a = 1", spaces_around_equal: :one, align_assignments: true

  assert_format "a+=1", "a += 1", spaces_around_equal: :one
  assert_format "a  +=  1", "a += 1", spaces_around_equal: :one
  assert_format "a  +=  1", "a += 1", spaces_around_equal: :dynamic, align_assignments: true
  assert_format "a  +=  1", "a += 1", spaces_around_equal: :one, align_assignments: true

  assert_format "def foo(x  =  1)\nend", "def foo(x = 1)\nend", spaces_around_equal: :one
  assert_format "def foo(x=1)\nend", "def foo(x = 1)\nend", spaces_around_equal: :one
  assert_format "def foo(x  =  1)\nend", spaces_around_equal: :dynamic
  assert_format "def foo(x=1)\nend", spaces_around_equal: :dynamic

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
  assert_format "foo  {  1  }", "foo  {  1  }", spaces_around_block_brace: :dynamic
  assert_format "->{1}", "->{1}", spaces_around_block_brace: :dynamic
  assert_format "->{1}", "->{ 1 }", spaces_around_block_brace: :one

  # spaces_after_comma
  assert_format "foo 1,  2,  3", "foo 1, 2, 3", spaces_after_comma: :one
  assert_format "foo 1,  2,  3", "foo 1,  2,  3", spaces_after_comma: :dynamic

  assert_format "foo(1,  2,  3)", "foo(1, 2, 3)", spaces_after_comma: :one
  assert_format "foo(1,  2,  3)", "foo(1,  2,  3)", spaces_after_comma: :dynamic

  assert_format "foo(1,2,3,x:1,y:2)", "foo(1, 2, 3, x:1, y:2)", spaces_after_comma: :one
  assert_format "foo(1,2,3,x:1,y:2)", spaces_after_comma: :dynamic

  assert_format "def foo(x,y)\nend", "def foo(x, y)\nend", spaces_after_comma: :one
  assert_format "def foo(x,y)\nend", spaces_after_comma: :dynamic

  assert_format "[1,  2,  3]", "[1, 2, 3]", spaces_after_comma: :one
  assert_format "[1,  2,  3]", "[1,  2,  3]", spaces_after_comma: :dynamic

  assert_format "[1,2,3]", "[1, 2, 3]", spaces_after_comma: :one
  assert_format "[1,2,3]", spaces_after_comma: :dynamic

  assert_format "a  ,  b = 1,  2", "a, b = 1, 2", spaces_after_comma: :one
  assert_format "a  ,  b = 1,  2", "a,  b = 1,  2", spaces_after_comma: :dynamic

  assert_format "a,b = 1,2", "a, b = 1, 2", spaces_after_comma: :one
  assert_format "a,b = 1,2", spaces_after_comma: :dynamic

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
  assert_format "case 1\nwhen  2  then  3\nelse  4\nend", "case 1\nwhen 2 then 3\nelse 4\nend", spaces_around_when: :one
  assert_format "case 1\nwhen  2  then  3\nelse  4\nend", spaces_around_when: :dynamic

  # spaces_around_dot
  assert_format "foo . bar", "foo . bar", spaces_around_dot: :dynamic
  assert_format "foo . bar = 1", "foo . bar = 1", spaces_around_dot: :dynamic
  assert_format "foo . bar", "foo.bar", spaces_around_dot: :no
  assert_format "foo . bar = 1", "foo.bar = 1", spaces_around_dot: :no

  # spaces_after_lambda_arrow
  assert_format "->  { }", "->  { }", spaces_after_lambda_arrow: :dynamic
  assert_format "->  { }", "->{ }", spaces_after_lambda_arrow: :no
  assert_format "->  { }", "-> { }", spaces_after_lambda_arrow: :one
  assert_format "->{ }", "-> { }", spaces_after_lambda_arrow: :one

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

  # spaces_after_method_name
  assert_format "def foo  (x)\nend", "def foo(x)\nend", spaces_after_method_name: :no
  assert_format "def foo  (x)\nend", spaces_after_method_name: :dynamic
  assert_format "def self.foo  (x)\nend", "def self.foo(x)\nend", spaces_after_method_name: :no
  assert_format "def self.foo  (x)\nend", spaces_after_method_name: :dynamic

  # spaces_in_inline_expressions
  assert_format "begin    end", spaces_in_inline_expressions: :dynamic
  assert_format "begin end", spaces_in_inline_expressions: :one

  assert_format "begin  1  end", spaces_in_inline_expressions: :dynamic
  assert_format "begin  1  end", "begin 1 end", spaces_in_inline_expressions: :one

  assert_format "def foo()  1  end", spaces_in_inline_expressions: :dynamic
  assert_format "def foo()  1  end", "def foo() 1 end", spaces_in_inline_expressions: :one

  assert_format "def foo(x)  1  end", spaces_in_inline_expressions: :dynamic
  assert_format "def foo(x)  1  end", "def foo(x) 1 end", spaces_in_inline_expressions: :one

  assert_format "\ndef foo1(x) 1 end\n def foo2(x) 2 end\n  def foo3(x) 3 end",
                "\ndef foo1(x) 1 end\ndef foo2(x) 2 end\ndef foo3(x) 3 end"

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
  assert_format " [ \n 1 ,  # comment  \n 2] ", "[\n  1,  # comment\n  2,\n]", trailing_commas: :always
  assert_format " [ 1 , \n 2, 3, \n 4 ] ", "[ 1,\n  2, 3,\n  4 ]", trailing_commas: :always
  assert_format " [ 1 , \n 2, 3, \n 4, ] ", "[ 1,\n  2, 3,\n  4 ]", trailing_commas: :always
  assert_format " [ 1 , \n 2, 3, \n 4,\n ] ", "[ 1,\n  2, 3,\n  4 ]", trailing_commas: :always
  assert_format " [ 1 , \n 2, 3, \n 4, # foo \n ] ", "[ 1,\n  2, 3,\n  4 # foo\n]", trailing_commas: :always
  assert_format " begin\n [ \n 1 , 2 ] \n end ", "begin\n  [\n    1, 2,\n  ]\nend", trailing_commas: :always
  assert_format " [ \n 1 # foo\n ]", "[\n  1, # foo\n]", trailing_commas: :always

  # align chained calls
  assert_format "foo . bar \n . baz", "foo . bar\n    . baz", align_chained_calls: true
  assert_format "foo . bar \n . baz \n . qux", "foo . bar\n    . baz\n    . qux", align_chained_calls: true
  assert_format "foo . bar( x.y ) \n . baz \n . qux", "foo . bar(x.y)\n    . baz\n    . qux", align_chained_calls: true
  assert_format "x.foo\n .bar { a.b }\n .baz"
=end
end
