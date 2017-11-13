---
title: "spaces\\_in\\_inline\\_expressions"
permalink: "/examples/spaces_in_inline_expressions/"
toc: true
sidebar:
  nav: "examples"
---

### spaces\_in\_inline\_expressions 1
```ruby
# GIVEN
begin end
```
```ruby
# BECOMES
begin end
```
### spaces\_in\_inline\_expressions 2
```ruby
# GIVEN
begin  1  end
```
```ruby
# BECOMES
begin 1 end
```
### spaces\_in\_inline\_expressions 3
```ruby
# GIVEN
def foo()  1  end
```
```ruby
# BECOMES
def foo() 1 end
```
### spaces\_in\_inline\_expressions 4
```ruby
# GIVEN
def foo(x)  1  end
```
```ruby
# BECOMES
def foo(x) 1 end
```
### spaces\_in\_inline\_expressions 5
```ruby
# GIVEN
def foo1(x) 1 end
 def foo2(x) 2 end
  def foo3(x) 3 end
```
```ruby
# BECOMES
def foo1(x) 1 end
def foo2(x) 2 end
def foo3(x) 3 end
```
