---
title: "parens\\_in\\_def"
permalink: "/examples/parens_in_def/"
toc: true
sidebar:
  nav: "examples"
---

### parens\_in\_def 1
```ruby
# GIVEN
def foo(x); end
```
```ruby
# BECOMES
def foo(x); end
```
### parens\_in\_def 2
```ruby
# GIVEN
def foo x; end
```
```ruby
# BECOMES
def foo(x); end
```
```ruby
# with setting `parens_in_def :dynamic`
def foo x; end
```
### parens\_in\_def 3
```ruby
# GIVEN
def foo(x); end
```
```ruby
# BECOMES
def foo(x); end
```
### parens\_in\_def 4
```ruby
# GIVEN
def foo x; end
```
```ruby
# BECOMES
def foo(x); end
```
```ruby
# with setting `parens_in_def :dynamic`
def foo x; end
```
