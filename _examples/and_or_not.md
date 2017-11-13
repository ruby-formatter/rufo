---
title: "and\\_or\\_not"
permalink: "/examples/and_or_not/"
toc: true
sidebar:
  nav: "examples"
---

### and\_or\_not 1
```ruby
# GIVEN
foo  and  bar
```
```ruby
# BECOMES
foo and bar
```
### and\_or\_not 2
```ruby
# GIVEN
foo  or  bar
```
```ruby
# BECOMES
foo or bar
```
### and\_or\_not 3
```ruby
# GIVEN
not  foo
```
```ruby
# BECOMES
not foo
```
### and\_or\_not 4
```ruby
# GIVEN
not(x)
```
```ruby
# BECOMES
not(x)
```
### and\_or\_not 5
```ruby
# GIVEN
not (x)
```
```ruby
# BECOMES
not(x)
```
### and\_or\_not 6
```ruby
# GIVEN
not((a, b = 1, 2))
```
```ruby
# BECOMES
not((a, b = 1, 2))
```
