---
title: "spaces\\_after\\_comma"
permalink: "/examples/spaces_after_comma/"
toc: true
sidebar:
  nav: "examples"
---

### spaces\_after\_comma 1
```ruby
# GIVEN
foo 1,  2,  3
```
```ruby
# BECOMES
foo 1, 2, 3
```
### spaces\_after\_comma 2
```ruby
# GIVEN
foo(1,  2,  3)
```
```ruby
# BECOMES
foo(1, 2, 3)
```
### spaces\_after\_comma 3
```ruby
# GIVEN
foo(1,2,3,x:1,y:2)
```
```ruby
# BECOMES
foo(1, 2, 3, x: 1, y: 2)
```
### spaces\_after\_comma 4
```ruby
# GIVEN
def foo(x,y)
end
```
```ruby
# BECOMES
def foo(x, y)
end
```
### spaces\_after\_comma 5
```ruby
# GIVEN
[1,  2,  3]
```
```ruby
# BECOMES
[1, 2, 3]
```
### spaces\_after\_comma 6
```ruby
# GIVEN
[1,2,3]
```
```ruby
# BECOMES
[1, 2, 3]
```
### spaces\_after\_comma 7
```ruby
# GIVEN
a  ,  b = 1,  2
```
```ruby
# BECOMES
a, b = 1, 2
```
### spaces\_after\_comma 8
```ruby
# GIVEN
a,b = 1,2
```
```ruby
# BECOMES
a, b = 1, 2
```
