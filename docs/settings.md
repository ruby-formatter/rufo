# Settings

Rufo supports limited configuration.
To configure Rufo, place a `.rufo` file in your project.
Each configuration is a call with one argument. For example:

```ruby
# .rufo
trailing_commas false
parens_in_def :dynamic
```

## :warning: Settings are going away! :warning:

The settings described below will be removed from future versions of rufo :skull:

See https://github.com/ruby-formatter/rufo/issues/2 for more context!

## Table of contents

- [parens_in_def](#parens_in_def)

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
