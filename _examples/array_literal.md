---
title: "array\\_literal"
permalink: "/examples/array_literal/"
toc: true
sidebar:
  nav: "examples"
---

### array\_literal 1
```ruby
# GIVEN
[  ]
```
```ruby
# BECOMES
[]
```
### array\_literal 2
```ruby
# GIVEN
[  1 ]
```
```ruby
# BECOMES
[1]
```
### array\_literal 3
```ruby
# GIVEN
[  1 , 2 ]
```
```ruby
# BECOMES
[1, 2]
```
### array\_literal 4
```ruby
# GIVEN
[  1 , 2 , ]
```
```ruby
# BECOMES
[1, 2]
```
### array\_literal 5
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
### array\_literal 6
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
### array\_literal 7
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
### array\_literal 8
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
### array\_literal 9
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
### array\_literal 10
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
### array\_literal 11
```ruby
# GIVEN
[  1 ,
 2, 3,
 4 ]
```
```ruby
# BECOMES
[1,
 2, 3,
 4]
```
### array\_literal 12
```ruby
# GIVEN
[  1 ,
 2, 3,
 4, ]
```
```ruby
# BECOMES
[1,
 2, 3,
 4]
```
### array\_literal 13
```ruby
# GIVEN
[  1 ,
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
### array\_literal 14
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
### array\_literal 15
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
### array\_literal 16
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
### array\_literal 17
```ruby
# GIVEN
[ *x ]
```
```ruby
# BECOMES
[*x]
```
### array\_literal 18
```ruby
# GIVEN
[ *x , 1 ]
```
```ruby
# BECOMES
[*x, 1]
```
### array\_literal 19
```ruby
# GIVEN
[ 1, *x ]
```
```ruby
# BECOMES
[1, *x]
```
### array\_literal 20
```ruby
# GIVEN
x = [{
 foo: 1
}]
```
```ruby
# BECOMES
x = [{
  foo: 1,
}]
```
```ruby
# with setting `trailing_commas false`
x = [{
  foo: 1
}]
```
### array\_literal 21
```ruby
# GIVEN
[1,   2]
```
```ruby
# BECOMES
[1, 2]
```
### array\_literal 22
```ruby
# GIVEN
[
  1,
  # comment
  2,
]
```
```ruby
# BECOMES
[
  1,
  # comment
  2,
]
```
```ruby
# with setting `trailing_commas false`
[
  1,
  # comment
  2
]
```
### array\_literal 23
```ruby
# GIVEN
[
  *a,
  b,
]
```
```ruby
# BECOMES
[
  *a,
  b,
]
```
```ruby
# with setting `trailing_commas false`
[
  *a,
  b
]
```
### array\_literal 24
```ruby
# GIVEN
[
  1, *a,
  b,
]
```
```ruby
# BECOMES
[
  1, *a,
  b,
]
```
```ruby
# with setting `trailing_commas false`
[
  1, *a,
  b
]
```
