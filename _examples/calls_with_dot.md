---
title: "calls\\_with\\_dot"
permalink: "/examples/calls_with_dot/"
toc: true
sidebar:
  nav: "examples"
---

### unnamed 224
```ruby
# GIVEN
foo.()
```
```ruby
# BECOMES
foo.()
```
### unnamed 225
```ruby
# GIVEN
foo.( 1 )
```
```ruby
# BECOMES
foo.(1)
```
### unnamed 226
```ruby
# GIVEN
foo.( 1, 2 )
```
```ruby
# BECOMES
foo.(1, 2)
```
### unnamed 227
```ruby
# GIVEN
x.foo.( 1, 2 )
```
```ruby
# BECOMES
x.foo.(1, 2)
```
