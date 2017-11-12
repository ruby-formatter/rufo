---
title: "array\\_access"
permalink: "/examples/array_access/"
toc: true
sidebar:
  nav: "examples"
---

### unnamed 81
```ruby
# GIVEN
foo[ ]
```
```ruby
# BECOMES
foo[]
```
### unnamed 82
```ruby
# GIVEN
foo[
 ]
```
```ruby
# BECOMES
foo[]
```
### unnamed 83
```ruby
# GIVEN
foo[ 1 ]
```
```ruby
# BECOMES
foo[1]
```
### unnamed 84
```ruby
# GIVEN
foo[ 1 , 2 , 3 ]
```
```ruby
# BECOMES
foo[1, 2, 3]
```
### unnamed 85
```ruby
# GIVEN
foo[ 1 ,
 2 ,
 3 ]
```
```ruby
# BECOMES
foo[1,
    2,
    3]
```
### unnamed 86
```ruby
# GIVEN
foo[
 1 ,
 2 ,
 3 ]
```
```ruby
# BECOMES
foo[
  1,
  2,
  3]
```
### unnamed 87
```ruby
# GIVEN
foo[ *x ]
```
```ruby
# BECOMES
foo[*x]
```
### unnamed 88
```ruby
# GIVEN
foo[
 1,
]
```
```ruby
# BECOMES
foo[
  1,
]
```
```ruby
# with setting `trailing_commas false`
foo[
  1
]
```
### unnamed 89
```ruby
# GIVEN
foo[
 1,
 2 , 3,
 4,
]
```
```ruby
# BECOMES
foo[
  1,
  2, 3,
  4,
]
```
```ruby
# with setting `trailing_commas false`
foo[
  1,
  2, 3,
  4
]
```
