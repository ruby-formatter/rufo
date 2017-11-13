---
title: "class\\_into\\_self"
permalink: "/examples/class_into_self/"
toc: true
sidebar:
  nav: "examples"
---

### class\_into\_self 1
```ruby
# GIVEN
class  <<  self 
 1 
 end
```
```ruby
# BECOMES
class << self
  1
end
```
