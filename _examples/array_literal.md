---
title: "array\\_literal"
permalink: "/examples/array_literal/"
toc: true
sidebar:
  nav: "examples"
---

### unnamed 90
```ruby
# GIVEN
[  ]
```
```ruby
# BECOMES
[]
```
### unnamed 91
```ruby
# GIVEN
[  1 ]
```
```ruby
# BECOMES
[1]
```
### unnamed 92
```ruby
# GIVEN
[  1 , 2 ]
```
```ruby
# BECOMES
[1, 2]
```
### unnamed 93
```ruby
# GIVEN
[  1 , 2 , ]
```
```ruby
# BECOMES
[1, 2]
```
### unnamed 94
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
### unnamed 95
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
### unnamed 96
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
### unnamed 97
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
### unnamed 98
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
### unnamed 99
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
### unnamed 100
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
### unnamed 101
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
### unnamed 102
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
### unnamed 103
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
### unnamed 104
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
### unnamed 105
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
### unnamed 106
```ruby
# GIVEN
[ *x ]
```
```ruby
# BECOMES
[*x]
```
### unnamed 107
```ruby
# GIVEN
[ *x , 1 ]
```
```ruby
# BECOMES
[*x, 1]
```
### unnamed 108
```ruby
# GIVEN
[ 1, *x ]
```
```ruby
# BECOMES
[1, *x]
```
### unnamed 109
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
### unnamed 110
```ruby
# GIVEN
[1,   2]
```
```ruby
# BECOMES
[1, 2]
```
### unnamed 111
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
### unnamed 112
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
### unnamed 113
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
