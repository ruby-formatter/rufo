---
title: "trailing\\_commas"
permalink: "/examples/trailing_commas/"
toc: true
sidebar:
  nav: "examples"
---

### unnamed 678
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
### unnamed 679
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
### unnamed 680
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
### unnamed 681
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
### unnamed 682
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
### unnamed 683
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
### unnamed 684
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
### unnamed 685
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
### unnamed 686
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
### unnamed 687
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
### unnamed 688
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
### unnamed 689
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
### unnamed 690
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
### unnamed 691
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
### unnamed 692
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
### unnamed 693
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
### unnamed 694
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
### unnamed 695
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
### unnamed 696
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
### unnamed 697
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
### unnamed 698
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
### unnamed 699
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
### unnamed 700
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
### unnamed 701
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
### unnamed 702
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
### unnamed 703
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
### unnamed 704
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
### unnamed 705
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
