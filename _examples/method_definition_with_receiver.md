---
title: "method\\_definition\\_with\\_receiver"
permalink: "/examples/method_definition_with_receiver/"
toc: true
sidebar:
  nav: "examples"
---

### method\_definition\_with\_receiver 1
```ruby
# GIVEN
def foo . 
 bar; end
```
```ruby
# BECOMES
def foo.bar; end
```
### method\_definition\_with\_receiver 2
```ruby
# GIVEN
def self . 
 bar; end
```
```ruby
# BECOMES
def self.bar; end
```
