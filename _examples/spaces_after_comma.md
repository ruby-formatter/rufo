---
title: "spaces\\_after\\_comma"
permalink: "/examples/spaces_after_comma/"
toc: true
sidebar:
  nav: "examples"
---

### unnamed 584
```ruby
# GIVEN
foo 1,  2,  3
```
```ruby
# BECOMES
foo 1, 2, 3
```
### unnamed 585
```ruby
# GIVEN
foo(1,  2,  3)
```
```ruby
# BECOMES
foo(1, 2, 3)
```
### unnamed 586
```ruby
# GIVEN
foo(1,2,3,x:1,y:2)
```
```ruby
# BECOMES
foo(1, 2, 3, x: 1, y: 2)
```
### unnamed 587
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
### unnamed 588
```ruby
# GIVEN
[1,  2,  3]
```
```ruby
# BECOMES
[1, 2, 3]
```
### unnamed 589
```ruby
# GIVEN
[1,2,3]
```
```ruby
# BECOMES
[1, 2, 3]
```
### unnamed 590
```ruby
# GIVEN
a  ,  b = 1,  2
```
```ruby
# BECOMES
a, b = 1, 2
```
### unnamed 591
```ruby
# GIVEN
a,b = 1,2
```
```ruby
# BECOMES
a, b = 1, 2
```
