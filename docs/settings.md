# Settings

Rufo supports limited configuration.
To configure Rufo, place a `.rufo` file in your project.
Each configuration is a call with one argument. For example:

```ruby
# .rufo
trailing_commas false
parens_in_def :dynamic
```

## Style settings are going away! :warning:

Style related settings described below may/will be removed from future versions of rufo :skull:

See https://github.com/ruby-formatter/rufo/issues/2 for more context!

## Table of contents

- [align_case_when](#align_case_when)
- [align_chained_calls](#align_chained_calls)
- [parens_in_def](#parens_in_def)
- [trailing_commas](#trailing_commas)
- [quote_style](#quote_style)
- [includes and excludes](#includes-and-excludes)

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

### parens_in_def

Use parentheses in defs?

- `:yes`: (default) always use parentheses (add them if they are not there)
- `:dynamic`: don't modify existing methods parentheses choice

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

### trailing_commas

Use trailing commas in array and hash literals, and keyword arguments?

- `true`: (default) always put a trailing comma
- `false`: never put a trailing comma

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

With `true`, the formatter will change it to:

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

With `false`, the formatter will change it to:

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

### quote_style

Use the specified quotation marks.

- `:double`: (default) use doublequotations unless one or more escaped double-quotations are included
- `:single`: use single quotations unless one or more interpolations `#{}` or escaped single quotations are included

This does not affect `%q()` (single), `%Q()` (double), or quotation marks within heredocs.

Given this code:

```ruby
'a great string'

'import \"quotes\"'
"import \'quotes\'"
"#{interpolation}"
%q(single quoted)
%Q(double quoted)
code = <<CODE
  "double"
  'single'
CODE
```

With `:double`, the formatter will change the first line to:

```ruby
"a great string"

'import \"quotes\"'
"import \'quotes\'"
"#{interpolation}"
%q(single quoted)
%Q(double quoted)
code = <<CODE
  "double"
  'single'
CODE
```

With `:single`, the formatter will change the first line just above to:

```ruby
'a great string'

'import \"quotes\"'
"import \'quotes\'"
"#{interpolation}"
%q(single quoted)
%Q(double quoted)
code = <<CODE
  "double"
  'single'
CODE
```

### Includes and excludes
Files can be excluded or included in formatting with rufo by specifying glob patterns for the `includes` or `excludes` configuration options. Multiple patterns are separated by a comma.

For example:
```
includes [*.txt,*.text]
excludes [**/*.erb]
```
