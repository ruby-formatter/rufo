---
title: "array\\_setter"
permalink: "/examples/array_setter/"
toc: true
sidebar:
  nav: "examples"
---

### array\_setter 1
```ruby
# GIVEN
foo[ ]  =  1
```
```ruby
# BECOMES
foo[] = 1
```
### array\_setter 2
```ruby
# GIVEN
foo[ 1 , 2 ]  =  3
```
```ruby
# BECOMES
foo[1, 2] = 3
```
