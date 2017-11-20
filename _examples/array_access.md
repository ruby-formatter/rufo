---
title: "array\\_access"
permalink: "/examples/array_access/"
toc: true
sidebar:
  nav: "examples"
---

### array\_access 1
```ruby
# GIVEN
foo[ ]
```
```ruby
# BECOMES
foo[]
```
### array\_access 2
```ruby
# GIVEN
foo[
 ]
```
```ruby
# BECOMES
foo[]
```
### array\_access 3
```ruby
# GIVEN
foo[ 1 ]
```
```ruby
# BECOMES
foo[1]
```
### array\_access 4
```ruby
# GIVEN
foo[ 1 , 2 , 3 ]
```
```ruby
# BECOMES
foo[1, 2, 3]
```
### array\_access 5
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
### array\_access 6
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
### array\_access 7
```ruby
# GIVEN
foo[ *x ]
```
```ruby
# BECOMES
foo[*x]
```
### array\_access 8
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
### array\_access 9
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
### array\_access 10
```ruby
# GIVEN
x[a] [b]
```
```ruby
# BECOMES
x[a][b]
```
