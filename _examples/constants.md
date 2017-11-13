---
title: "constants"
permalink: "/examples/constants/"
toc: true
sidebar:
  nav: "examples"
---

### constants 1
```ruby
# GIVEN
Foo
```
```ruby
# BECOMES
Foo
```
### constants 2
```ruby
# GIVEN
Foo::Bar::Baz
```
```ruby
# BECOMES
Foo::Bar::Baz
```
### constants 3
```ruby
# GIVEN
Foo::Bar::Baz
```
```ruby
# BECOMES
Foo::Bar::Baz
```
### constants 4
```ruby
# GIVEN
Foo:: Bar:: Baz
```
```ruby
# BECOMES
Foo::Bar::Baz
```
### constants 5
```ruby
# GIVEN
Foo:: 
Bar
```
```ruby
# BECOMES
Foo::Bar
```
### constants 6
```ruby
# GIVEN
::Foo
```
```ruby
# BECOMES
::Foo
```
### constants 7
```ruby
# GIVEN
::Foo::Bar
```
```ruby
# BECOMES
::Foo::Bar
```
### constants 8
```ruby
# GIVEN
::Foo = 1
```
```ruby
# BECOMES
::Foo = 1
```
### constants 9
```ruby
# GIVEN
::Foo::Bar = 1
```
```ruby
# BECOMES
::Foo::Bar = 1
```
