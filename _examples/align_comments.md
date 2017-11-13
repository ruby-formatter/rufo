---
title: "align\\_comments"
permalink: "/examples/align_comments/"
toc: true
sidebar:
  nav: "examples"
---

### align\_comments 1
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
### align\_comments 2
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
### align\_comments 3
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
### align\_comments 4
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
### align\_comments 5
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
### align\_comments 6
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
### align\_comments 7
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
### align\_comments 8
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
### align\_comments 9
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
### align\_comments 10
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
### align\_comments 11
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
### align\_comments 12
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
### align\_comments 13
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
### align\_comments 14
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
### align\_comments 15
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
### align\_comments 16
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
