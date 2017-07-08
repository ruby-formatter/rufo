# Rufo

[![Build Status](https://travis-ci.org/asterite/rufo.svg)](https://travis-ci.org/asterite/rufo)

**Ru**by **fo**rmatter

## Why

Rufo's primary use case is as a text-editor plugin, to autoformat files on save or
on demand. For this reason it needs to be fast. If the formatter is slow, saving
a file becomes painful.

Right now, Rufo can format it's [formatter](https://github.com/asterite/rufo/blob/master/lib/rufo/formatter.rb),
a 3000+ lines file, in about 290ms. It can format a ~500 lines file in 180ms. Since most files
have less than 500 lines, the time is acceptable.

There's at least one other good Ruby formatter I know: [RuboCop](https://github.com/bbatsov/rubocop).
However, it takes between 2 and 5 seconds to format a 3000+ lines file, and about 1 second to format
a 500 lines file. A second is too much delay for a plugin editor. Additionally, RuboCop is much more
than just a code formatter. Rufo is and will always be a code formatter.

## Unobtrusive by default

We Ruby programmers think code beauty and readability is very important. We might align code
in some ways that a formatter would come and destroy. Many are against automatic code formatters
for this reason.

By default, Rufo is configured in a way that these decisions are preserved. In this way you
can start using it in your favorite text editor without forcing your whole team to start using it.

For example, this code:

```ruby
class Foo
  include Bar
  extend  Baz
end
```

has an extra space after `extend`, but by doing that `Bar` becomes aligned with `Baz`.
It might look better for some, and Rufo preserves this choice by default.

A similar example is aligning call arguments:

```ruby
register :command, "Format"
register :action,  "Save"
```

Here too, an extra space is added to align `"Format"` with `"Save"`. Again, Rufo will preserve
this choice.

Another example is aligning call parameters:

```ruby
# Align with respect to the first parameter
foo 1, 2,
    3, 4,
    5

# Align by regular indent (2 spaces)
foo 1, 2,
  3, 4,
  5

# Align arrays
foo 1, [
         2,
         3,
       ]

# Don't extra align arrays:
foo 1, [
  2,
  3,
]

# Aling trailing calls
assert foo(
         1
       )

# Don't extra align trailing calls
assert foo(
  1
)
```

All of the alignment choices above are fine depending on the context where they are
used, and Rufo will not destroy that choice. It will, however, keep things aligned
so they look good.

If Rufo does not change these things by default, what does it do? Well, it makes sure that:

- code at the beginning of a line is correctly indented
- array and hash elements are aligned
- there are no spaces **before** commas
- there are no more than one consecutive empty lines
- methods are separated by an empty line
- no trailing semicolons remain
- no trailing whitespace remains
- a trailing newline at the end of the file remains

And of course it can be configured to do more. Check the settings section below.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rufo'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rufo

## Usage

### Format files or directories

```
$ rufo file names or dir names
```

### Format STDIN

```
$ cat file.rb | rufo
```

### Check that no formatting changes are produced

```
$ rufo --check file names or dir names
```

This will print one line for each file that isn't correctly formatted
according to **rufo**, and will exit with exit code 1.

## Editor support

- Atom: [rufo-atom](https://github.com/bmulvihill/rufo-atom) :construction:
- Emacs [emacs-rufo](https://github.com/aleandros/emacs-rufo) :construction: or [rufo-mode.el](https://github.com/danielma/rufo-mode.el) :construction:
- Sublime Text: [sublime-rufo](https://github.com/asterite/sublime-rufo)
- Vim: [rufo-vim](https://github.com/splattael/rufo-vim)
- Visual Studio Code: [rufo-vscode](https://marketplace.visualstudio.com/items?itemName=siliconsenthil.rufo-vscode)


Did you write a plugin for your favorite editor? That's great! Let me know about it and
I will list it here.

### Tips for editor plugins implementors

Rufo works best, and it's incredibly convenient, when code is automatically
formatted on save. In this way you can for example surround a piece of code with
`if ... end` and it gets automatically indented, or unindented when you remove
such code.

For this to work best, the cursor position must be preserved, otherwise it becomes
pretty annoying if the cursor is reset at the top of the editor.

You should compute a diff between the old content and new content
and apply the necessary editions. You can check out how this is done in the
[Sublime Text plugin for Rufo](https://github.com/asterite/sublime-rufo):

- [diff_match_patch.py](https://github.com/asterite/sublime-rufo/blob/master/diff_match_patch.py) contains the diff algorithm (you can port it to other languages or try to search for a similar algorithm online)
- [rufo_format.py](https://github.com/asterite/sublime-rufo/blob/master/rufo_format.py#L46-L53) consumes the diff result and applies it chunk by chunk in the editor's view

## Configuration

To configure Rufo, place a `.rufo` file in your project. When formatting a file or a directory
via the `rufo` program, a `.rufo` file will try to be found in that directory or parent directories.

The `.rufo` file is a Ruby file that is evaluated in the context of the formatter.
The available configurations are listed below.

### indent_size

Sets the indent size. Default: 2

### spaces_inside_hash_brace

Allow spaces inside hash braces?

- `:dynamic`: (default) if there's a space, keep it. Otherwise don't add it.
- `:always`: always add a space
- `:never`: never add a space
- `:match`: if there's a leading space, keep it (just one) and match the closing brace with one space before it

With `:always`, hashes will look like this:

```ruby
{ :foo => 1, :bar => 2 }
```

With `:never`, hashes will look like this:

```ruby
{:foo => 1, :bar => 2}
```

With `:match`, hashes will look like any of these:

```ruby
{ :foo => 1, :bar => 2 }
{:foo => 1, :bar => 2}
```

With `:dynamic`, any of the above choices is fine, and any amount of space (or zero) is preserved.

### spaces_inside_array_bracket

Allow spaces inside array brackets?

- `:dynamic`: (default) if there's a space, keep it. Otherwise don't add it.
- `:always`: always add a space
- `:never`: never add a space
- `:match`: if there's a leading space, keep it (just one) and match the closing bracket with one space before it

With `:always`, arrays will look like this:

```ruby
[ 1, 2 ]
```

With `:never`, arrays will look like this:

```ruby
[1, 2]
```

With `:match`, arrays will look like any of these:

```ruby
[ 1, 2 ]
[1, 2]
```

With `:dynamic`, any of the above choices is fine.

### spaces_around_equal

How to format spaces around an equal (`=`) sign?

- `:dynamic`: (default) allow any number of spaces (even zero) around the equal sign
- `:one`: always use one space before and after the equal sign

Given this code:

```ruby
a=1
b  =  2
```

With `:one` the formatter will change it to:

```ruby
a = 1
b = 2
```

With `:dynamic` it won't modify it.

If `align_assignments` is `true`, then this setting has no effect and `:one`
will be used when no other assignments are above/below an assignment.

### spaces_in_ternary

How to format spaces around a ternary (`cond ? then : else`) operator?

- `:dynamic`: (default) allow any number of spaces (even zero) around `?` and `:`
- `:one`: always use one space before and after `?` and `:`

Given this code:

```ruby
a?b:c
a  ?  b  :  c
```

With `:one` the formatter will change it to:

```ruby
a ? b : c
a ? b : c
```

With `:dynamic` it won't modify it.

### spaces_in_suffix

How to format spaces around a suffix `if`, `unless`, etc?

- `:dynamic`: (default) allow any number of spaces (even zero) around `if`
- `:one`: always use one space before and after `if`

Given this code:

```ruby
a  if  b
```

With `:one` the formatter will change it to:

```ruby
a if b
```

With `:dynamic` it won't modify it.

### spaces_in_commands

How to format spaces after command names (a command is a call without parentheses)?

- `:dynamic`: (default) allow any number of spaces after a command name
- `:one`: always use one space after a command name

Given this code:

```ruby
include Foo
extend  Bar
```

With `:one` the formatter will change it to:

```ruby
include Foo
extend Bar
```

With `:dynamic` it won't modify it.

### spaces_around_block_brace

How to format spaces around block braces?

- `:dynamic`: (default) allow any number of spaces around block braces
- `:one`: always use one space around block braces

Given this code:

```ruby
foo{|x|1}
foo {|x|1}
foo { |x|1}
foo { |x| 1}
```

With `:one` the formatter will change it to:

```ruby
foo { |x| 1 }
foo { |x| 1 }
foo { |x| 1 }
foo { |x| 1 }
```

With `:dynamic` it won't modify it.

### spaces_after_comma

How to format spaces after commas?

- `:dynamic`: (default) allow any number of spaces around block braces
- `:one`: always use one space after a comma

Given this code:

```ruby
foo 1,  2,   3
[1,  2,  3]
```

With `:one` the formatter will change it to:

```ruby
foo 1, 2, 3
[1, 2, 3]
```

With `:dynamic` it won't modify it.

### spaces_around_hash_arrow

How to format spaces around a hash arrow or keyword argument?

- `:dynamic`: (default) allow any number of spaces around hash arrows
- `:one`: always use one space around hash arrows

Given this code:

```ruby
{ 1  =>  2, 3    =>  4 }
{ foo:  1,  bar:  2 }
```

With `:one` the formatter will change it to:

```ruby
{ 1 => 2, 3 => 4 }
{ foo: 1, bar: 2}
```

With `:dynamic` it won't modify it.

If `align_hash_keys` is `true`, then this setting has no effect and `:one`
will be used when no other hash keys are above/below.

### spaces_around_when

How to format spaces around a case when and then?

- `:dynamic`: (default) allow any number of spaces around a case when and then
- `:one`: always use one space around a case when and then

Given this code:

```ruby
case foo
when   1  then 2
end
```

With `:one` the formatter will change it to:

```ruby
case foo
when 1 then 2
end
```

With `:dynamic` it won't modify it.

If `align_case_when` is `true`, then this setting has no effect and `:one`
will be used when no other case when are above/below.

### spaces_around_dot

How to format spaces around a call dot?

- `:dynamic`: (default) allow any number of spaces around a call dot
- `:no`: no spaces around a call dot

Given this code:

```ruby
foo .  bar
foo :: bar
foo &. bar
```

With `:no` the formatter will change it to:

```ruby
foo.bar
foo::bar
foo&.bar
```

With `:dynamic` it won't modify it.

### spaces_after_lambda_arrow

How to format spaces after a lambda arrow?

- `:dynamic`: (default) allow any number of spaces after a lambda arrow
- `:no`: no spaces after a lambda arrow

Given this code:

```ruby
->{ 1 }
->  { 2 }
```

With `:no` the formatter will change it to:

```ruby
->{ 1 }
->{ 2 }
```

With `:dynamic` it won't modify it.

For spaces inside the braces, the `spaces_around_block_brace` setting is used.

### spaces_around_unary

How to format spaces around a unary operator?

- `:dynamic`: (default) allow any number of spaces around a unary operator
- `:no`: no spaces around a unary operator

Given this code:

```ruby
+1
-  2
! x
```

With `:no` the formatter will change it to:

```ruby
+1
-2
!x
```

With `:dynamic` it won't modify it.

### spaces_around_binary

How to format spaces around a binary operator?

- `:dynamic`: (default) allow any number of spaces around a binary operator
- `:one`: at most one space around a binary operator

Given this code:

```ruby
1+2
1 +2
1+ 2
1  +  2
```

With `:one` the formatter will change it to:

```ruby
1+2
1 + 2
1+2
1 + 2
```

Note that with `:one` the spaces are kept balanced: if there's no space
before the operator, no space is kept after it. If there's a space
before the operator, a space is added after it.

With `:dynamic` it won't modify it.

### spaces_after_method_name

How to format spaces after a method name?

- `:dynamic`: (default) allow any number of spaces
- `:no`: no spaces after a method name

Given this code:

```ruby
def plus_one   (x) x + 1 end
def plus_twenty(x) x + 20 end
```

With `:no` the formatter will change it to:

```ruby
def plus_one(x) x + 1 end
def plus_twenty(x) x + 20 end
```

With `:dynamic` it won't modify it.

## spaces_in_inline_expressions

How to format spaces in inline expressions?

- `:dynamic`: (default) allow any number of spaces
- `:one`: one space in inline expressions

Given this code:

```ruby
begin  1  end

def foo(x)  2  end
```

With `:one` the formatter will change it to:

```ruby
begin 1 end

def foo(x) 2 end
```

With `:dynamic` it won't modify it.

### parens_in_def

Use parentheses in defs?

- `:dynamic`: (default) don't modify existing methods parentheses choice
- `:yes`: always use parentheses (add them if they are not there)

Given this code:

```ruby
def foo x, y
end

def bar(x, y)
end
```

With `:yes` the formatter will change it to:

```ruby
def foo(x, y)
end

def bar(x, y)
end
```

With `:dynamic` it won't modify it.

### double_newline_inside_type

Allow an empty line inside a type declaration?

- `:dynamic`: (default) allow at most one empty newline
- `:no`: no empty newlines inside type declarations

Given this code:

```ruby
class Foo

  CONST = 1

end

class Bar
  CONST = 2
 end
```

With `:no` the formatter will change it to:

```ruby
class Foo
  CONST = 1
end

class Bar
  CONST = 2
end
```

With `:dynamic` it won't modify it.

### visibility_indent

How to indent code after a visibility method (`public`, `protected`, `private`)?

- `:dynamic`: (default) keep the current code's choice according to the first expression that follows
- `:indent`: indent code after the visibility method
- `:align`: align code at the same column as the visibility method

Given this code:

```ruby
class Foo
  private

  def foo
  end

    def bar
    end
end

class Bar
  private

    def foo
    end

  def bar
  end
end
```

With `:dynamic`, the formatter will change it to:

```ruby
class Foo
  private

  def foo
  end

  def bar
  end
end

class Bar
  private

    def foo
    end

    def bar
    end
end
```

Note that the formatter unified the indentation choice according to the first
expression. It makes no sense to keep two choices together inside a same type
declaration.

With `:align`, the formatter will change it to:

```ruby
class Foo
  private

  def foo
  end

  def bar
  end
end

class Bar
  private

  def foo
  end

  def bar
  end
end
```

With `:indent`, the formatter will change it to:

```ruby
class Foo
  private

  def foo
  end

    def bar
    end
end

class Bar
  private

    def foo
    end

    def bar
    end
end
```

**NOTE:** There's another commonly used indentation style which is `:dedent`:

```ruby
class Foo
  def foo
  end

private

  def bar
  end
end
```

Rufo currently doesn't support it, but in the future it might.

### align_comments

Align successive comments?

- `false`: (default) don't align comments (preserve existing code)
- `true`: align successive comments

Given this code:

```ruby
foo = 1 # some comment
barbaz = 2 # some other comment
```

With `true`, the formatter will change it to:

```ruby
foo = 1    # some comment
barbaz = 2 # some other comment
```

With `false` it won't modify it.

### align_assignments

Align successive assignments?

- `false`: (default) don't align assignments (preserve existing code)
- `true`: align successive assignments

Given this code:

```ruby
foo = 1
barbaz = 2
```

With `true`, the formatter will change it to:

```ruby
foo    = 1
barbaz = 2
```

With `false` it won't modify it.

### align_hash_keys

Align successive hash keys?

- `false`: (default) don't align hash keys (preserve existing code)
- `true`: align successive hash keys

Given this code:

```ruby
{
  foo: 1,
  barbaz: 2,
}

{
  :foo => 1,
  :barbaz => 2,
}

method foo: 1,
       barbaz: 2
```

With `true`, the formatter will change it to:

```ruby
{
  foo:    1,
  barbaz: 2,
}

{
  :foo =>    1,
  :barbaz => 2,
}

method foo:    1,
       barbaz: 2
```

With `false` it won't modify it.

### align_case_when

Align successive case when?

- `false`: (default) don't align case when (preserve existing code)
- `true`: align successive case when

Given this code:

```ruby
case exp
when foo then 2
when barbaz then 3
end
```

With `true`, the formatter will change it to:

```ruby
case exp
when foo    then 2
when barbaz then 3
end
```

With `false` it won't modify it.

### align_chained_calls

Align chained calls to the dot?

- `false`: (default) don't align chained calls to the dot (preserve existing code)
- `true`: align chained calls to the dot

Given this code:

```ruby
foo.bar
   .baz

foo.bar
  .baz
```

With `true`, the formatter will change it to:

```ruby
foo.bar
   .baz

foo.bar
   .baz
```

With `false` it won't modify it.

Note that with `false` it will keep it aligned to the dot if it's already like that.

### trailing_commas

Use trailing commas in array and hash literals, and keyword arguments?

- `:dynamic`: (default) if there's a trailing comma, keep it. Otherwise, don't remove it
- `:always`: always put a trailing comma
- `:never`: never put a trailing comma

Given this code:

```ruby
[
  1,
  2
]

[
  1,
  2,
]

{
  foo: 1,
  bar: 2
}

{
  foo: 1,
  bar: 2,
}

foo(
  x: 1,
  y: 2
)

foo(
  x: 1,
  y: 2,
)
```

With `:always`, the formatter will change it to:

```ruby
[
  1,
  2,
]

[
  1,
  2,
]

{
  foo: 1,
  bar: 2,
}

{
  foo: 1,
  bar: 2,
}

foo(
  x: 1,
  y: 2,
)

foo(
  x: 1,
  y: 2,
)
```
With `:never`, the formatter will change it to:

```ruby
[
  1,
  2
]

[
  1,
  2
]

{
  foo: 1,
  bar: 2
}

{
  foo: 1,
  bar: 2
}

foo(
  x: 1,
  y: 2
)

foo(
  x: 1,
  y: 2
)
```

With `:dynamic` it won't modify it.

## How it works

Rufo is a **real** formatter, not a simple find and replace one. It works by employing
a Ruby parser and a Ruby lexer. The parser is used for the shape of the program. The program
is traversed and the lexer is used to sync this structure to tokens. This is why comments
can be handled well, because they are provided by the lexer (comments are not returned by
a parser).

To parse and lex, [Ripper](https://ruby-doc.org/stdlib-2.4.0/libdoc/ripper/rdoc/Ripper.html) is used.

As a reference, this was implemented in a similar fashion to [Crystal](https://github.com/crystal-lang/crystal)'s formatter.

And as a side note, rufo has **no dependencies**. It only depends on `rspec` for tests, but that's it.
That means it loads very fast (no need to read many Ruby files), and because `Ripper` is mostly written
in C (uses Ruby's lexer and parser) it formats files pretty fast too.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/asterite/rufo.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
