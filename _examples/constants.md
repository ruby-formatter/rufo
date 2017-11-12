---
title: "constants"
permalink: "/examples/constants/"
toc: true
sidebar:
  nav: "examples"
---

### unnamed 308
```ruby
# GIVEN
Foo
```
```ruby
# BECOMES
Foo
```
### unnamed 309
```ruby
# GIVEN
Foo::Bar::Baz
```
```ruby
# BECOMES
Foo::Bar::Baz
```
### unnamed 310
```ruby
# GIVEN
Foo::Bar::Baz
```
```ruby
# BECOMES
Foo::Bar::Baz
```
### unnamed 311
```ruby
# GIVEN
Foo:: Bar:: Baz
```
```ruby
# BECOMES
Foo::Bar::Baz
```
### unnamed 312
```ruby
# GIVEN
Foo:: 
Bar
```
```ruby
# BECOMES
Foo::Bar
```
### unnamed 313
```ruby
# GIVEN
::Foo
```
```ruby
# BECOMES
::Foo
```
### unnamed 314
```ruby
# GIVEN
::Foo::Bar
```
```ruby
# BECOMES
::Foo::Bar
```
### unnamed 315
```ruby
# GIVEN
::Foo = 1
```
```ruby
# BECOMES
::Foo = 1
```
### unnamed 316
```ruby
# GIVEN
::Foo::Bar = 1
```
```ruby
# BECOMES
::Foo::Bar = 1
```
