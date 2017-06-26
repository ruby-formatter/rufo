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

- Sublime Text: [sublime-rufo](https://github.com/asterite/sublime-rufo)
- Vim: [rufo-vim](https://github.com/splattael/rufo-vim) :construction:

Did you write a plugin for your favorite editor? That's great! Let me know about it and
I will list it here.

Right now it would be great to have [Atom](https://atom.io/) and [Emacs](https://www.gnu.org/software/emacs/) plugins :-)

## Configuration

Rufo follows most of the conventions found in this [Ruby style guide](https://github.com/bbatsov/ruby-style-guide). It does a bit more than that, and it can also be configured a bit.

To configure it, place a `.rufo` file in your project. When formatting a file or a directory
via the `rufo` program, a `.rufo` file will try to be found in that directory or parent directories.

The `.rufo` file is a Ruby file that is evaluated in the context of the formatter. These are the
available configurations:

```ruby
# Whether to put a space after a hash brace. Valid values are:
#
# * :dynamic: if there's a space, keep it. If not, don't keep it (default)
# * :always: always put a space after a hash brace
# * :never: never put a space after a hash brace
space_after_hash_brace :dynamic

# Whether to align successive comments (default: true)
align_comments true

# Whether to align successive assignments (default: false)
align_assignments false

# Whether to align successive hash keys (default: true)
align_hash_keys true

# Whether to align successive case when (default: true)
align_case_when true

# Preserve whitespace after assignments target and values,
# after calls that start with a space, hash arrows and commas (default: true).
#
# This allows for manual alignment of some code that would otherwise
# be impossible to automatically format or preserve "beautiful".
#
# If `align_assignments` is true, this doesn't apply to assignments.
# If `align_hash_keys` is true, this doesn't apply to hash keys.
preserve_whitespace true

# The indent size (default: 2)
indent_size 2

# Whether to place commas at the end of a multi-line list (default: true).
trailing_commas true
```

As time passes there might be more configurations available. Please open an
issue if you need something else to be configurable.

## Formatting rules

Rufo follows most of the conventions found in this [Ruby style guide](https://github.com/bbatsov/ruby-style-guide).

However, there are some differences. Some of them are:

### `*`, `/` and `**` don't require spaces around them

All of these are good:

```ruby
# First option
2*x + 3*y + z

# Second option
2 * x + 3 * y + z

# Another option
2 * x + 3*y + z
```

Rufo will leave them as they are. The reason is that the first format looks
good mathematically. If you do insert a space before the `*` operator,
a space will be inserted afterwards.

## Status

The formatter is able to format `rails` and other projects, so at this point
it's pretty mature. There might still be some bugs. Don't hesitate
to open an issue if you find something is not working well. In any case, if the formatter
chokes on some valid input you will get an error prompting you to submit a bug report here :-)

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
