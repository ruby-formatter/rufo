# Rufo

[![CircleCI](https://circleci.com/gh/ruby-formatter/rufo.svg?style=svg)](https://circleci.com/gh/ruby-formatter/rufo)
[![Gem](https://img.shields.io/gem/v/rufo.svg)](https://rubygems.org/gems/rufo)

**Ru**by **fo**rmatter


Rufo is as an _opinionated_ ruby formatter, intended to be used via the command line as a text-editor plugin, to autoformat files on save or on demand.

Unlike the best known Ruby formatter [RuboCop](https://github.com/bbatsov/rubocop), Rufo offers little in the way of configuration. Like other language formatters such as [gofmt](https://golang.org/cmd/gofmt/), [prettier](https://github.com/prettier/prettier), and [autopep8](https://github.com/hhatto/autopep8), we strive to find a "one true format" for Ruby code, and make sure your code adheres to it, with zero config where possible.

RuboCop does much more than just format code though, so feel free to run them both!

Rufo supports all Ruby versions >= 2.4.**5**, due to a bug in Ruby's Ripper parser.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rufo'
```

And then execute:

    $ bundle

Or install it system wide with:

    $ gem install rufo

## Editor support

Once the gem is installed, enable format on save integration in your editor of choice with the following libraries:

- Atom: [rufo-atom](https://github.com/bmulvihill/rufo-atom) :construction:
- Emacs [emacs-rufo](https://github.com/aleandros/emacs-rufo) :construction: or [rufo.el](https://github.com/danielma/rufo.el)
- Sublime Text: [sublime-rufo](https://github.com/ruby-formatter/sublime-rufo)
- Vim: [rufo-vim](https://github.com/splattael/rufo-vim)
- Visual Studio Code: [vscode-rufo](https://marketplace.visualstudio.com/items?itemName=mbessey.vscode-rufo) or [rufo-vscode](https://marketplace.visualstudio.com/items?itemName=siliconsenthil.rufo-vscode)

If you're interested in developing your own plugin check out the [development docs](docs/developing-rufo.md). Did you already write a plugin? That's great! Let us know about it and
we will list it here.


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
this choice, while still enforcing that truly badly aligned code is formatted.

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

## Usage

### Format files or directories

```
# All directories (recursive)
$ rufo .

# Specific file or directory
$ rufo [file or directory name]
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


## Configuration

Rufo supports limited configuration.
To configure Rufo, place a `.rufo` file in your project. Then when you format a file or a directory,
Rufo will look for a `.rufo` file in that directory or parent directories and apply the configuration.

The `.rufo` file is a Ruby file that is evaluated in the context of the formatter.
The available settings are listed [here](docs/settings.md).

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

Bug reports and pull requests are welcome on GitHub at https://github.com/ruby-formatter/rufo.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
