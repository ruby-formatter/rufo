# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed

### Changed

### Added

## [0.13.0] - 2021-05-07

### Fixed

- Properly format comma when a heredoc is passed as a call argument
- Correctly interpret case statements with multiple when clauses in ERB files

### Changed

- Dropped support for Ruby 2.4 and 2.5 as they are end of life.

### Added

- Add Ruby 3.0.1 to test runs on CI.

## [0.12.0] - 2020-03-08

### Fixed

- File.read default encode UTF-8
- Handle case where the code is invalid but ripper does not raise an error.
- Removed implicit dependency on `rake`.
- Error when semicolon and then used in a case statement #230.

### Changed

### Added
- Code coverage tracking with codecov.io
- `node_modules` folders are now ignored.

## [0.11.0] - 2020-02-09

### Fixed
- Documentation for `trailing_commas`
- Handle empty string symbol for key in hash.

### Added
- Support for escaped ERB template tags. For example `<%%%%= format :name %>`.

## [0.10.0] - 2020-01-16

### Fixed
- Squiggly heredoc closing tag indentation.
- Formatting .erb files from stdin.

### Changed
- Method parameters are now no longer aligned with the method parenthesis. For example:
  - ```ruby
    def foo(
            param
           )
    end

    # Becomes:

    def foo(
      param
    )
    end
    ```
- Multiline assignments are no longer aligned with variable indentation.
  - ```ruby
    a = if true
          b
        end

    # Becomes:

    a = if true
        b
      end
    ```
### Added

## [0.9.0] - 2020-01-11

### Added

- Support for trim style erb templates ending with `-%>`.
- Support for rails raw mode erb templates starting with `<%==`.
- Support for ruby 2.7 features. This includes beginless ranges `..10`, method argument forwarding `def forward(...); to(...); end` and keyword args not being allowed `def foo(*args, **nil)`.

## [0.8.1] - 2020-01-02

### Fixed
- Formatting a folder. For example `rufo lib` was not working.

### Changed

### Added
- Documentation for `includes` and `excludes` configuration options.

## [0.8.0] - 2020-01-02

### Fixed
- Handle endless ranges in ruby 2.6
- Handle empty string hash keys

### Changed
- Output detailed description of Syntax Error to log
- Removed newlines from start of files.

### Added

- Support for rackup files
- Settings for 'quote_style' to settings.md
- Add support for ERB files
- Add Ruby 2.7.0 to test runs on CI
- `includes` and `excludes` configuration options

## [0.7.0] - 2019-04-28

### Fixed
- Argument align with splat (issue [123](https://github.com/ruby-formatter/rufo/issues/123))

### Changed

### Added
- Support jbuilder files (issue [173](https://github.com/ruby-formatter/rufo/issues/173))

## [0.6.1] - 2019-04-27

### Fixed
- Fix bug: symbol literal like `:"foo"` in ruby 2.6.3 (issue [168](https://github.com/ruby-formatter/rufo/issues/168))

## [0.6.0] - 2019-03-04

### Fixed
- Fix odd indentation of nested one liner "if" statements (issue [128](https://github.com/ruby-formatter/rufo/issues/128))

### Added
- Ignore `vendor` directories from files to be checked. This allows rufo to be run without any arguments against a directory both locally and on common CI tools without needing any configuration.
- Allow logging level to be configured with `--loglevel[=LEVEL]`.

### Changed
- Dropped support for ruby 2.3 as it is end of life.
- Remove space before paren for short lambda syntax `-> () {}` becomes `->() {}`.

## [0.5.1] - 2019-02-13

### Fixed

- Fix bug: Rufo crashes on nested empty hash literal (issue [152](https://github.com/ruby-formatter/rufo/issues/152))
- Handle case where rufo would change formatting if run multiple times for hashes in some cases.

## [0.5.0] - 2019-02-09

### Added

- Add space inside hash literal braces when contents are on the same line. `{a: 1} => { a: 1 }`. This brings Rufo inline with:
  - [RuboCop](https://www.rubydoc.info/gems/rubocop/RuboCop/Cop/Layout/SpaceInsideHashLiteralBraces)
  - [Prettier](https://prettier.io/docs/en/options.html#bracket-spacing)
  - [RSpec core](https://github.com/rspec/rspec-core/blob/7b6b9c3f2e2878213f97d6fc9e9eb23c323cfe1c/lib/rspec/core/bisect/shell_command.rb#L49)
  - [Rails activemodel](https://github.com/rails/rails/blob/master/activemodel/lib/active_model/validations/acceptance.rb#L7)
  - [Devise](https://github.com/plataformatec/devise/blob/master/app/controllers/devise/sessions_controller.rb#L44)
- Format gem and Rake related files.

## [0.4.2] - 2019-01-22

### Fixed
- Fix bug: Rufo indents squiggly HEREDOC incorrectly causing bad formating (issue [136](https://github.com/ruby-formatter/rufo/issues/136))

### Added

- Chore: Added ruby 2.6.0 to CI test runs.

## [0.4.1] - 2018-10-27

### Fixed
- Fix bug for double colon operator in method definition (issue [#120](https://github.com/ruby-formatter/rufo/issues/120))

## [0.4.0] - 2018-08-09

### Fixed
- Fix Bug: Rufo breaks HEREDOC syntax. (issue [#88](https://github.com/ruby-formatter/rufo/issues/88)). This fixes heredoc within parens formatting causing bad formatting and subsequent syntax error.
- Fix Bug: formatter.rb:3700:in `block in adjust_other_alignments': undefined method `[]' for nil:NilClass (NoMethodError) (issue [#87](https://github.com/ruby-formatter/rufo/issues/87)). Check alignment target exists.
- Fix Bug: Rufo keeps switching formatting on same file every time it runs (issue [#86](https://github.com/ruby-formatter/rufo/issues/86)). Avoids re-indenting nested literal indents.

### Added
- Allow for simpler else_body node to suit new Ripper style in 2.6.0
- Allow new Ripper node :excessed_comma in block parsing
- Allow :bodystmt in lambda nodes to suit Ripper format in 2.6.0
- Drop support for ruby 2.2
- Set minimum required ruby version. As rufo is not tested on unsupported versions it may (and is known to) break code.

## [0.3.1] - 2018-04-12

### Fixed
- Fix `quote_style` config not being respected (issue [#95](https://github.com/ruby-formatter/rufo/issues/95)).

## [0.3.0] - 2018-03-24

### Added
- Added Idempotency check to source_specs/ tester.
- Normalize string quotes according to quote_style, which defaults to :double.

### Fixed
- Fix printing of extraneous trailing semicolons from inline classes, modules, methods (issue [#59](https://github.com/ruby-formatter/rufo/issues/59))
- Fix unhandled white space between array getter/setters `x[0] [0]` (issue [#62](https://github.com/ruby-formatter/rufo/issues/62))
- Fix comma printing for heredocs when inside a hash (issue [#61](https://github.com/ruby-formatter/rufo/issues/61))
- Fix array literals against changes to Ruby 2.5.0

## [0.2.0] - 2017-11-13
### Changed
Config parsing and handling:
- No longer using `eval` to parse config files
- Warnings have been added for invalid config keys and values

The default for the following options has changed:
- parens_in_def: `:dynamic` > `:yes`
- trailing_commas: `:dynamic` > `true`

Valid options for:
- trailing_commas: `[:always, :never]` > `[true, false]`

### Removed
The following configuration options have been **removed**, and replaced with non-configurable sane defaults, [per discussion](https://github.com/ruby-formatter/rufo/issues/2):
- align_assignments
- align_comments
- align_hash_keys
- indent_size
- spaces_after_comma
- spaces_after_lambda_arrow
- spaces_around_block_brace
- spaces_around_dot
- spaces_around_equal
- spaces_around_hash_arrow
- spaces_around_unary
- spaces_around_when
- spaces_in_commands
- spaces_in_suffix
- spaces_in_ternary
- spaces_inside_array_bracket
- spaces_inside_hash_brace
- visibility_indent
- double_newline_inside_type
- spaces_around_binary

### Fixed
- Fix crash in Ruby <= 2.3.4, <= 2.4.1 in the presence of certain squiggly doc (`<<~`) with multiple embedded expressions. The real fix here is to upgrade Ruby to >= 2.3.5 / >= 2.4.2
- Fix dedent bug and bad formatting caused by comments within chained calls (issue [#49](https://github.com/ruby-formatter/rufo/issues/49))
- Fix formatting bug for `for i, in [[1, 2]] ; x ; end` (issue [#45](https://github.com/ruby-formatter/rufo/issues/45))

## [0.1.0] - 2017-10-08
Beginning of logging changes!
