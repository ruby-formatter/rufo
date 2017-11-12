---
title: "spaces\\_in\\_inline\\_expressions"
permalink: "/examples/spaces_in_inline_expressions/"
toc: true
sidebar:
  nav: "examples"
---

### unnamed 626
```ruby
# GIVEN
begin end
```
```ruby
# BECOMES
begin end
```
### unnamed 627
```ruby
# GIVEN
begin  1  end
```
```ruby
# BECOMES
begin 1 end
```
### unnamed 628
```ruby
# GIVEN
def foo()  1  end
```
```ruby
# BECOMES
def foo() 1 end
```
### unnamed 629
```ruby
# GIVEN
def foo(x)  1  end
```
```ruby
# BECOMES
def foo(x) 1 end
```
### unnamed 630
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
