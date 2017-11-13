---
title: "spaces\\_in\\_ternary"
permalink: "/examples/spaces_in_ternary/"
toc: true
sidebar:
  nav: "examples"
---

### spaces\_in\_ternary 1
```ruby
# GIVEN
1?2:3
```
```ruby
# BECOMES
1 ? 2 : 3
```
### spaces\_in\_ternary 2
```ruby
# GIVEN
1  ?  2  :  3
```
```ruby
# BECOMES
1 ? 2 : 3
```
