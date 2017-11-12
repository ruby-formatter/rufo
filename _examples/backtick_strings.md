---
title: "backtick\\_strings"
permalink: "/examples/backtick_strings/"
toc: true
sidebar:
  nav: "examples"
---

### unnamed 131
```ruby
# GIVEN
`cat meow`
```
```ruby
# BECOMES
`cat meow`
```
### unnamed 132
```ruby
# GIVEN
%x( cat meow )
```
```ruby
# BECOMES
%x( cat meow )
```
