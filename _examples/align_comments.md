---
title: "align\\_comments"
permalink: "/examples/align_comments/"
toc: true
sidebar:
  nav: "examples"
---

### unnamed 36
```ruby
# GIVEN
1 # one
 123 # two
```
```ruby
# BECOMES
1 # one
123 # two
```
### unnamed 37
```ruby
# GIVEN
1 # one
 123 # two
 4
 5 # lala
```
```ruby
# BECOMES
1 # one
123 # two
4
5 # lala
```
### unnamed 38
```ruby
# GIVEN
foobar( # one
 1 # two
)
```
```ruby
# BECOMES
foobar( # one
  1 # two
)
```
### unnamed 39
```ruby
# GIVEN
a = 1 # foo
 abc = 2 # bar
```
```ruby
# BECOMES
a = 1 # foo
abc = 2 # bar
```
### unnamed 40
```ruby
# GIVEN
a = 1 # foo
      # bar
```
```ruby
# BECOMES
a = 1 # foo
      # bar
```
### unnamed 41
```ruby
# GIVEN
# foo
a # bar
```
```ruby
# BECOMES
# foo
a # bar
```
### unnamed 42
```ruby
# GIVEN
# foo
a # bar
```
```ruby
# BECOMES
# foo
a # bar
```
### unnamed 43
```ruby
# GIVEN
require x

# Comment 1
# Comment 2
FOO = :bar # Comment 3
```
```ruby
# BECOMES
require x

# Comment 1
# Comment 2
FOO = :bar # Comment 3
```
### unnamed 44
```ruby
# GIVEN
begin
  require x

  # Comment 1
  # Comment 2
  FOO = :bar # Comment 3
end
```
```ruby
# BECOMES
begin
  require x

  # Comment 1
  # Comment 2
  FOO = :bar # Comment 3
end
```
### unnamed 45
```ruby
# GIVEN
begin
  a     # c1
        # c2
  b = 1 # c3
end
```
```ruby
# BECOMES
begin
  a     # c1
        # c2
  b = 1 # c3
end
```
### unnamed 46
```ruby
# GIVEN
1 # one
 123 # two
```
```ruby
# BECOMES
1 # one
123 # two
```
### unnamed 47
```ruby
# GIVEN
foo bar( # foo
  1,     # bar
)
```
```ruby
# BECOMES
foo bar( # foo
  1,     # bar
)
```
```ruby
# with setting `trailing_commas false`
foo bar( # foo
  1     # bar
)
```
### unnamed 48
```ruby
# GIVEN
a = 1   # foo
bar = 2 # baz
```
```ruby
# BECOMES
a = 1   # foo
bar = 2 # baz
```
### unnamed 49
```ruby
# GIVEN
[
  1,   # foo
  234,   # bar
]
```
```ruby
# BECOMES
[
  1,   # foo
  234,   # bar
]
```
```ruby
# with setting `trailing_commas false`
[
  1,   # foo
  234   # bar
]
```
### unnamed 50
```ruby
# GIVEN
[
  1,   # foo
  234    # bar
]
```
```ruby
# BECOMES
[
  1,   # foo
  234,    # bar
]
```
```ruby
# with setting `trailing_commas false`
[
  1,   # foo
  234    # bar
]
```
### unnamed 51
```ruby
# GIVEN
foo bar: 1,  # comment
    baz: 2    # comment
```
```ruby
# BECOMES
foo bar: 1,  # comment
    baz: 2    # comment
```
