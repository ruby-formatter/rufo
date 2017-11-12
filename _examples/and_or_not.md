---
title: "and\\_or\\_not"
permalink: "/examples/and_or_not/"
toc: true
sidebar:
  nav: "examples"
---

### unnamed 75
```ruby
# GIVEN
foo  and  bar
```
```ruby
# BECOMES
foo and bar
```
### unnamed 76
```ruby
# GIVEN
foo  or  bar
```
```ruby
# BECOMES
foo or bar
```
### unnamed 77
```ruby
# GIVEN
not  foo
```
```ruby
# BECOMES
not foo
```
### unnamed 78
```ruby
# GIVEN
not(x)
```
```ruby
# BECOMES
not(x)
```
### unnamed 79
```ruby
# GIVEN
not (x)
```
```ruby
# BECOMES
not(x)
```
### unnamed 80
```ruby
# GIVEN
not((a, b = 1, 2))
```
```ruby
# BECOMES
not((a, b = 1, 2))
```
