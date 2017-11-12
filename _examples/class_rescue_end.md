---
title: "class\\_rescue\\_end"
permalink: "/examples/class_rescue_end/"
toc: true
sidebar:
  nav: "examples"
---

### unnamed 288
```ruby
# GIVEN
class Foo 
 raise 'bar' 
 rescue Baz =>  ex 
 end
```
```ruby
# BECOMES
class Foo
  raise 'bar'
rescue Baz => ex
end
```
