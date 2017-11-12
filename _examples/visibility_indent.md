---
title: "visibility\\_indent"
permalink: "/examples/visibility_indent/"
toc: true
sidebar:
  nav: "examples"
---

### unnamed 718
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
### unnamed 719
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
### unnamed 720
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
### unnamed 721
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
### unnamed 722
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
### unnamed 723
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
