---
title: "spaces\\_around\\_equal"
permalink: "/examples/spaces_around_equal/"
toc: true
sidebar:
  nav: "examples"
---

### spaces\_around\_equal 1
```ruby
# GIVEN
a=1
```
```ruby
# BECOMES
a = 1
```
### spaces\_around\_equal 2
```ruby
# GIVEN
a  =  1
```
```ruby
# BECOMES
a = 1
```
### spaces\_around\_equal 3
```ruby
# GIVEN
a  =  1
```
```ruby
# BECOMES
a = 1
```
### spaces\_around\_equal 4
```ruby
# GIVEN
a+=1
```
```ruby
# BECOMES
a += 1
```
### spaces\_around\_equal 5
```ruby
# GIVEN
a  +=  1
```
```ruby
# BECOMES
a += 1
```
### spaces\_around\_equal 6
```ruby
# GIVEN
a  +=  1
```
```ruby
# BECOMES
a += 1
```
### spaces\_around\_equal 7
```ruby
# GIVEN
def foo(x  =  1)
end
```
```ruby
# BECOMES
def foo(x = 1)
end
```
### spaces\_around\_equal 8
```ruby
# GIVEN
def foo(x=1)
end
```
```ruby
# BECOMES
def foo(x = 1)
end
```
