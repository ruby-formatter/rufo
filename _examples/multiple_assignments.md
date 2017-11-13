---
title: "multiple\\_assignments"
permalink: "/examples/multiple_assignments/"
toc: true
sidebar:
  nav: "examples"
---

### multiple\_assignments 1
```ruby
# GIVEN
a  =   1  ,   2
```
```ruby
# BECOMES
a = 1, 2
```
### multiple\_assignments 2
```ruby
# GIVEN
a , b  = 2
```
```ruby
# BECOMES
a, b = 2
```
### multiple\_assignments 3
```ruby
# GIVEN
a , b, ( c, d )  = 2
```
```ruby
# BECOMES
a, b, (c, d) = 2
```
### multiple\_assignments 4
```ruby
# GIVEN
*x = 1
```
```ruby
# BECOMES
*x = 1
```
### multiple\_assignments 5
```ruby
# GIVEN
a , b , *x = 1
```
```ruby
# BECOMES
a, b, *x = 1
```
### multiple\_assignments 6
```ruby
# GIVEN
*x , a , b = 1
```
```ruby
# BECOMES
*x, a, b = 1
```
### multiple\_assignments 7
```ruby
# GIVEN
a, b, *x, c, d = 1
```
```ruby
# BECOMES
a, b, *x, c, d = 1
```
### multiple\_assignments 8
```ruby
# GIVEN
a, b, = 1
```
```ruby
# BECOMES
a, b, = 1
```
### multiple\_assignments 9
```ruby
# GIVEN
a = b, *c
```
```ruby
# BECOMES
a = b, *c
```
### multiple\_assignments 10
```ruby
# GIVEN
a = b, *c, *d
```
```ruby
# BECOMES
a = b, *c, *d
```
### multiple\_assignments 11
```ruby
# GIVEN
a, = b
```
```ruby
# BECOMES
a, = b
```
### multiple\_assignments 12
```ruby
# GIVEN
a = b, c, *d
```
```ruby
# BECOMES
a = b, c, *d
```
### multiple\_assignments 13
```ruby
# GIVEN
a = b, c, *d, e
```
```ruby
# BECOMES
a = b, c, *d, e
```
### multiple\_assignments 14
```ruby
# GIVEN
*, y = z
```
```ruby
# BECOMES
*, y = z
```
### multiple\_assignments 15
```ruby
# GIVEN
w, (x,), y = z
```
```ruby
# BECOMES
w, (x,), y = z
```
### multiple\_assignments 16
```ruby
# GIVEN
a, b=1, 2
```
```ruby
# BECOMES
a, b = 1, 2
```
### multiple\_assignments 17
```ruby
# GIVEN
* = 1
```
```ruby
# BECOMES
* = 1
```
