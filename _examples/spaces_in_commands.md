---
title: "spaces\\_in\\_commands"
permalink: "/examples/spaces_in_commands/"
toc: true
sidebar:
  nav: "examples"
---

### spaces\_in\_commands 1
```ruby
# GIVEN
foo  1
```
```ruby
# BECOMES
foo 1
```
### spaces\_in\_commands 2
```ruby
# GIVEN
foo.bar  1
```
```ruby
# BECOMES
foo.bar 1
```
### spaces\_in\_commands 3
```ruby
# GIVEN
not x
```
```ruby
# BECOMES
not x
```
### spaces\_in\_commands 4
```ruby
# GIVEN
not  x
```
```ruby
# BECOMES
not x
```
### spaces\_in\_commands 5
```ruby
# GIVEN
defined?  1
```
```ruby
# BECOMES
defined? 1
```
