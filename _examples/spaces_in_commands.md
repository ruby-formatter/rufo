---
title: "spaces\\_in\\_commands"
permalink: "/examples/spaces_in_commands/"
toc: true
sidebar:
  nav: "examples"
---

### unnamed 621
```ruby
# GIVEN
foo  1
```
```ruby
# BECOMES
foo 1
```
### unnamed 622
```ruby
# GIVEN
foo.bar  1
```
```ruby
# BECOMES
foo.bar 1
```
### unnamed 623
```ruby
# GIVEN
not x
```
```ruby
# BECOMES
not x
```
### unnamed 624
```ruby
# GIVEN
not  x
```
```ruby
# BECOMES
not x
```
### unnamed 625
```ruby
# GIVEN
defined?  1
```
```ruby
# BECOMES
defined? 1
```
