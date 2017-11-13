---
title: "backtick\\_strings"
permalink: "/examples/backtick_strings/"
toc: true
sidebar:
  nav: "examples"
---

### backtick\_strings 1
```ruby
# GIVEN
`cat meow`
```
```ruby
# BECOMES
`cat meow`
```
### backtick\_strings 2
```ruby
# GIVEN
%x( cat meow )
```
```ruby
# BECOMES
%x( cat meow )
```
