---
title: "trailing\\_commas"
permalink: "/examples/trailing_commas/"
toc: true
sidebar:
  nav: "examples"
---

### trailing\_commas 1
```ruby
# GIVEN
[
  1,
  2,
]
```
```ruby
# BECOMES
[
  1,
  2,
]
```
```ruby
# with setting `trailing_commas false`
[
  1,
  2
]
```
### trailing\_commas 2
```ruby
# GIVEN
[
  1,
  2,
]
```
```ruby
# BECOMES
[
  1,
  2,
]
```
```ruby
# with setting `trailing_commas false`
[
  1,
  2
]
```
### trailing\_commas 3
```ruby
# GIVEN
[
  1,
  2
]
```
```ruby
# BECOMES
[
  1,
  2,
]
```
```ruby
# with setting `trailing_commas false`
[
  1,
  2
]
```
### trailing\_commas 4
```ruby
# GIVEN
[
  1,
  2
]
```
```ruby
# BECOMES
[
  1,
  2,
]
```
```ruby
# with setting `trailing_commas false`
[
  1,
  2
]
```
### trailing\_commas 5
```ruby
# GIVEN
{
  foo: 1,
  bar: 2,
}
```
```ruby
# BECOMES
{
  foo: 1,
  bar: 2,
}
```
```ruby
# with setting `trailing_commas false`
{
  foo: 1,
  bar: 2
}
```
### trailing\_commas 6
```ruby
# GIVEN
{
  foo: 1,
  bar: 2,
}
```
```ruby
# BECOMES
{
  foo: 1,
  bar: 2,
}
```
```ruby
# with setting `trailing_commas false`
{
  foo: 1,
  bar: 2
}
```
### trailing\_commas 7
```ruby
# GIVEN
{
  foo: 1,
  bar: 2
}
```
```ruby
# BECOMES
{
  foo: 1,
  bar: 2,
}
```
```ruby
# with setting `trailing_commas false`
{
  foo: 1,
  bar: 2
}
```
### trailing\_commas 8
```ruby
# GIVEN
{
  foo: 1,
  bar: 2
}
```
```ruby
# BECOMES
{
  foo: 1,
  bar: 2,
}
```
```ruby
# with setting `trailing_commas false`
{
  foo: 1,
  bar: 2
}
```
### trailing\_commas 9
```ruby
# GIVEN
foo(
  one:   1,
  two:   2,
  three: 3,
)
```
```ruby
# BECOMES
foo(
  one: 1,
  two: 2,
  three: 3,
)
```
```ruby
# with setting `trailing_commas false`
foo(
  one: 1,
  two: 2,
  three: 3
)
```
### trailing\_commas 10
```ruby
# GIVEN
foo(
  one:   1,
  two:   2,
  three: 3,
)
```
```ruby
# BECOMES
foo(
  one: 1,
  two: 2,
  three: 3,
)
```
```ruby
# with setting `trailing_commas false`
foo(
  one: 1,
  two: 2,
  three: 3
)
```
### trailing\_commas 11
```ruby
# GIVEN
foo(
  one:   1,
  two:   2,
  three: 3
)
```
```ruby
# BECOMES
foo(
  one: 1,
  two: 2,
  three: 3,
)
```
```ruby
# with setting `trailing_commas false`
foo(
  one: 1,
  two: 2,
  three: 3
)
```
### trailing\_commas 12
```ruby
# GIVEN
foo(
  one:   1,
  two:   2,
  three: 3
)
```
```ruby
# BECOMES
foo(
  one: 1,
  two: 2,
  three: 3,
)
```
```ruby
# with setting `trailing_commas false`
foo(
  one: 1,
  two: 2,
  three: 3
)
```
### trailing\_commas 13
```ruby
# GIVEN
foo(
  one: 1)
```
```ruby
# BECOMES
foo(
  one: 1,
)
```
```ruby
# with setting `trailing_commas false`
foo(
  one: 1
)
```
### trailing\_commas 14
```ruby
# GIVEN
foo(
  one: 1)
```
```ruby
# BECOMES
foo(
  one: 1,
)
```
```ruby
# with setting `trailing_commas false`
foo(
  one: 1
)
```
### trailing\_commas 15
```ruby
# GIVEN
foo(
  one: 1,)
```
```ruby
# BECOMES
foo(
  one: 1,
)
```
```ruby
# with setting `trailing_commas false`
foo(
  one: 1
)
```
### trailing\_commas 16
```ruby
# GIVEN
foo(
  one: 1,)
```
```ruby
# BECOMES
foo(
  one: 1,
)
```
```ruby
# with setting `trailing_commas false`
foo(
  one: 1
)
```
### trailing\_commas 17
```ruby
# GIVEN
[
 1 , 2 ]
```
```ruby
# BECOMES
[
  1, 2,
]
```
```ruby
# with setting `trailing_commas false`
[
  1, 2
]
```
### trailing\_commas 18
```ruby
# GIVEN
[
 1 , 2, ]
```
```ruby
# BECOMES
[
  1, 2,
]
```
```ruby
# with setting `trailing_commas false`
[
  1, 2
]
```
### trailing\_commas 19
```ruby
# GIVEN
[
 1 , 2 ,
 3 , 4 ]
```
```ruby
# BECOMES
[
  1, 2,
  3, 4,
]
```
```ruby
# with setting `trailing_commas false`
[
  1, 2,
  3, 4
]
```
### trailing\_commas 20
```ruby
# GIVEN
[
 1 ,
 2]
```
```ruby
# BECOMES
[
  1,
  2,
]
```
```ruby
# with setting `trailing_commas false`
[
  1,
  2
]
```
### trailing\_commas 21
```ruby
# GIVEN
[  # comment
 1 ,
 2]
```
```ruby
# BECOMES
[ # comment
  1,
  2,
]
```
```ruby
# with setting `trailing_commas false`
[ # comment
  1,
  2
]
```
### trailing\_commas 22
```ruby
# GIVEN
[
 1 ,  # comment
 2]
```
```ruby
# BECOMES
[
  1,  # comment
  2,
]
```
```ruby
# with setting `trailing_commas false`
[
  1,  # comment
  2
]
```
### trailing\_commas 23
```ruby
# GIVEN
[ 1 ,
 2, 3,
 4 ]
```
```ruby
# BECOMES
[1,
 2, 3,
 4]
```
### trailing\_commas 24
```ruby
# GIVEN
[ 1 ,
 2, 3,
 4, ]
```
```ruby
# BECOMES
[1,
 2, 3,
 4]
```
### trailing\_commas 25
```ruby
# GIVEN
[ 1 ,
 2, 3,
 4,
 ]
```
```ruby
# BECOMES
[1,
 2, 3,
 4]
```
### trailing\_commas 26
```ruby
# GIVEN
[ 1 ,
 2, 3,
 4, # foo
 ]
```
```ruby
# BECOMES
[1,
 2, 3,
 4 # foo
]
```
### trailing\_commas 27
```ruby
# GIVEN
begin
 [
 1 , 2 ]
 end
```
```ruby
# BECOMES
begin
  [
    1, 2,
  ]
end
```
```ruby
# with setting `trailing_commas false`
begin
  [
    1, 2
  ]
end
```
### trailing\_commas 28
```ruby
# GIVEN
[
 1 # foo
 ]
```
```ruby
# BECOMES
[
  1, # foo
]
```
```ruby
# with setting `trailing_commas false`
[
  1 # foo
]
```
