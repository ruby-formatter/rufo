---
title: "defined?"
permalink: "/examples/defined_qu/"
toc: true
sidebar:
  nav: "examples"
---

### unnamed 317
```ruby
# GIVEN
defined?  1
```
```ruby
# BECOMES
defined? 1
```
### unnamed 318
```ruby
# GIVEN
defined? ( 1 )
```
```ruby
# BECOMES
defined? (1)
```
### unnamed 319
```ruby
# GIVEN
defined?(1)
```
```ruby
# BECOMES
defined?(1)
```
### unnamed 320
```ruby
# GIVEN
defined?((a, b = 1, 2))
```
```ruby
# BECOMES
defined?((a, b = 1, 2))
```
