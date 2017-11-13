---
title: "symbol\\_literals"
permalink: "/examples/symbol_literals/"
toc: true
sidebar:
  nav: "examples"
---

### symbol\_literals 1
```ruby
# GIVEN
:foo
```
```ruby
# BECOMES
:foo
```
### symbol\_literals 2
```ruby
# GIVEN
:"foo"
```
```ruby
# BECOMES
:"foo"
```
### symbol\_literals 3
```ruby
# GIVEN
:"foo#{1}"
```
```ruby
# BECOMES
:"foo#{1}"
```
### symbol\_literals 4
```ruby
# GIVEN
:*
```
```ruby
# BECOMES
:*
```
