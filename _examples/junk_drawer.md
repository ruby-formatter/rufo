---
title: "junk\\_drawer"
permalink: "/examples/junk_drawer/"
toc: true
sidebar:
  nav: "examples"
---

### junk\_drawer 1
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
### junk\_drawer 2
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
### junk\_drawer 3
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
### junk\_drawer 4
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
