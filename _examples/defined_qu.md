---
title: "defined?"
permalink: "/examples/defined_qu/"
toc: true
sidebar:
  nav: "examples"
---

### defined? 1
```ruby
# GIVEN
defined?  1
```
```ruby
# BECOMES
defined? 1
```
### defined? 2
```ruby
# GIVEN
defined? ( 1 )
```
```ruby
# BECOMES
defined? (1)
```
### defined? 3
```ruby
# GIVEN
defined?(1)
```
```ruby
# BECOMES
defined?(1)
```
### defined? 4
```ruby
# GIVEN
defined?((a, b = 1, 2))
```
```ruby
# BECOMES
defined?((a, b = 1, 2))
```
