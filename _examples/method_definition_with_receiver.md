---
title: "method\\_definition\\_with\\_receiver"
permalink: "/examples/method_definition_with_receiver/"
toc: true
sidebar:
  nav: "examples"
---

### unnamed 493
```ruby
# GIVEN
def foo . 
 bar; end
```
```ruby
# BECOMES
def foo.bar; end
```
### unnamed 494
```ruby
# GIVEN
def self . 
 bar; end
```
```ruby
# BECOMES
def self.bar; end
```
