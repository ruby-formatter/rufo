---
title: "visibility\\_indent"
permalink: "/examples/visibility_indent/"
toc: true
sidebar:
  nav: "examples"
---

### visibility\_indent 1
```ruby
# GIVEN
private

foo
bar
```
```ruby
# BECOMES
private

foo
bar
```
### visibility\_indent 2
```ruby
# GIVEN
private

  foo
bar
```
```ruby
# BECOMES
private

foo
bar
```
### visibility\_indent 3
```ruby
# GIVEN
private

  foo
bar

protected

  baz
```
```ruby
# BECOMES
private

foo
bar

protected

baz
```
### visibility\_indent 4
```ruby
# GIVEN
private

  foo
bar

protected

  baz
```
```ruby
# BECOMES
private

foo
bar

protected

baz
```
### visibility\_indent 5
```ruby
# GIVEN
class Foo
  private

    foo
end
```
```ruby
# BECOMES
class Foo
  private

  foo
end
```
### visibility\_indent 6
```ruby
# GIVEN
class << self
  private

    foo
end
```
```ruby
# BECOMES
class << self
  private

  foo
end
```
