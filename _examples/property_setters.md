---
title: "property\\_setters"
permalink: "/examples/property_setters/"
toc: true
sidebar:
  nav: "examples"
---

### property\_setters 1
```ruby
# GIVEN
foo . bar  =  1
```
```ruby
# BECOMES
foo.bar = 1
```
### property\_setters 2
```ruby
# GIVEN
foo . bar  =
 1
```
```ruby
# BECOMES
foo.bar =
  1
```
### property\_setters 3
```ruby
# GIVEN
foo .
 bar  =
 1
```
```ruby
# BECOMES
foo.
  bar =
  1
```
### property\_setters 4
```ruby
# GIVEN
foo:: bar  =  1
```
```ruby
# BECOMES
foo::bar = 1
```
### property\_setters 5
```ruby
# GIVEN
foo:: bar  =
 1
```
```ruby
# BECOMES
foo::bar =
  1
```
### property\_setters 6
```ruby
# GIVEN
foo::
 bar  =
 1
```
```ruby
# BECOMES
foo::
  bar =
  1
```
