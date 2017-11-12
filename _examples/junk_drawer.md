---
title: "junk\\_drawer"
permalink: "/examples/junk_drawer/"
toc: true
sidebar:
  nav: "examples"
---

### unnamed 383
```ruby
# GIVEN
def foo
end
def bar
end
```
```ruby
# BECOMES
def foo
end

def bar
end
```
### unnamed 384
```ruby
# GIVEN
class Foo
end
class Bar
end
```
```ruby
# BECOMES
class Foo
end

class Bar
end
```
### unnamed 385
```ruby
# GIVEN
module Foo
end
module Bar
end
```
```ruby
# BECOMES
module Foo
end

module Bar
end
```
### unnamed 386
```ruby
# GIVEN
1
def foo
end
```
```ruby
# BECOMES
1

def foo
end
```
