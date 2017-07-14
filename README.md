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
# Align with respect to the first parameter:
foo 1, 2,
    3, 4,
    5

# Align by regular indent (2 spaces):
foo 1, 2,
  3, 4,
  5

# Align arrays:
foo 1, [
         2,
         3,
       ]

# Don't extra align arrays:
foo 1, [
  2,
  3,
]

# Align trailing calls:
assert foo(
         1
       )

# Don't extra align trailing calls:
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

And of course it can be configured to do much more.
Check the [Settings](https://github.com/asterite/rufo/wiki/Settings) section in the [Wiki](https://github.com/asterite/rufo/wiki) for more details.

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
according to **Rufo**, and will exit with exit code 3.

### Exit codes

| Code | Result |
| ---- | ---- |
| `0` | No errors, but also no formatting changes |
| `1` | Error. Either `Ripper` could not parse syntax or input file is missing |
| `3` | Input changed. Formatted code differs from input |

## Editor support

- Atom: [rufo-atom](https://github.com/bmulvihill/rufo-atom) :construction:
- Emacs [emacs-rufo](https://github.com/aleandros/emacs-rufo) :construction: or [rufo.el](https://github.com/danielma/rufo.el)
- Sublime Text: [sublime-rufo](https://github.com/asterite/sublime-rufo)
- Vim: [rufo-vim](https://github.com/splattael/rufo-vim)
- Visual Studio Code: [rufo-vscode](https://marketplace.visualstudio.com/items?itemName=siliconsenthil.rufo-vscode) or [vscode-rufo](https://marketplace.visualstudio.com/items?itemName=mbessey.vscode-rufo)


Did you write a plugin for your favorite editor? That's great! Let me know about it and
I will list it here.

### Tips for editor plugin implementors

It is especially convenient if your code is automatically _formatted on save_.
For example, surrounding a piece of code with `if ... end` will automatically indent
the code when you save. Likewise, it will be automatically unindented should you remove it.

For this to work best, the cursor position must be preserved, otherwise it becomes
pretty annoying if the cursor is reset to the top of the editor.

You should compute a diff between the old content and new content
and apply the necessary changes. You can check out how this is done in the
[Sublime Text plugin for Rufo](https://github.com/asterite/sublime-rufo):

- [diff_match_patch.py](https://github.com/asterite/sublime-rufo/blob/master/diff_match_patch.py) contains the diff algorithm (you can port it to other languages or try to search for a similar algorithm online)
- [rufo_format.py](https://github.com/asterite/sublime-rufo/blob/master/rufo_format.py#L46-L53) consumes the diff result and applies it chunk by chunk in the editor's view

## Configuration

To configure Rufo, place a `.rufo` file in your project. Then when you format a file or a directory,
Rufo will look for a `.rufo` file in that directory or parent directories and apply the configuration.

The `.rufo` file is a Ruby file that is evaluated in the context of the formatter.
The available settings are listed [here](https://github.com/asterite/rufo/wiki/Settings).

## How it works

Rufo is a **real** formatter, not a simple find and replace one. It works by employing
a Ruby parser and a Ruby lexer. The parser is used for the shape of the program. The program
is traversed and the lexer is used to sync this structure to tokens. This is why comments
can be handled well, because they are provided by the lexer (comments are not returned by
a parser).

To parse and lex, [Ripper](https://ruby-doc.org/stdlib-2.4.0/libdoc/ripper/rdoc/Ripper.html) is used.

As a reference, this was implemented in a similar fashion to [Crystal](https://github.com/crystal-lang/crystal)'s formatter.

And as a side note, Rufo has **no dependencies**. To run Rufo's specs you will require [rspec](https://github.com/rspec/rspec), but that's it.
This means Rufo loads very fast (no need to read many Ruby files), and since [Ripper](https://ruby-doc.org/stdlib-2.4.0/libdoc/ripper/rdoc/Ripper.html) is mostly written
in C (uses Ruby's lexer and parser) it formats files pretty fast too.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/asterite/rufo.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
