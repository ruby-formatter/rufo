---
title: "spaces\\_after\\_method\\_name"
permalink: "/examples/spaces_after_method_name/"
toc: true
sidebar:
  nav: "examples"
---

### spaces\_after\_method\_name 1
```ruby
# GIVEN
def foo  (x)
end
```
```ruby
# BECOMES
def foo(x)
end
```
### spaces\_after\_method\_name 2
```ruby
# GIVEN
def self.foo  (x)
end
```
```ruby
# BECOMES
def self.foo(x)
end
```
