---
title: "calls\\_with\\_dot"
permalink: "/examples/calls_with_dot/"
toc: true
sidebar:
  nav: "examples"
---

### calls\_with\_dot 1
```ruby
# GIVEN
foo.()
```
```ruby
# BECOMES
foo.()
```
### calls\_with\_dot 2
```ruby
# GIVEN
foo.( 1 )
```
```ruby
# BECOMES
foo.(1)
```
### calls\_with\_dot 3
```ruby
# GIVEN
foo.( 1, 2 )
```
```ruby
# BECOMES
foo.(1, 2)
```
### calls\_with\_dot 4
```ruby
# GIVEN
x.foo.( 1, 2 )
```
```ruby
# BECOMES
x.foo.(1, 2)
```
