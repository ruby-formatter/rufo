---
title: "spaces\\_around\\_block\\_brace"
permalink: "/examples/spaces_around_block_brace/"
toc: true
sidebar:
  nav: "examples"
---

### spaces\_around\_block\_brace 1
```ruby
# GIVEN
foo{1}
```
```ruby
# BECOMES
foo { 1 }
```
### spaces\_around\_block\_brace 2
```ruby
# GIVEN
foo{|x|1}
```
```ruby
# BECOMES
foo { |x| 1 }
```
### spaces\_around\_block\_brace 3
```ruby
# GIVEN
foo  {  1  }
```
```ruby
# BECOMES
foo { 1 }
```
### spaces\_around\_block\_brace 4
```ruby
# GIVEN
->{1}
```
```ruby
# BECOMES
-> { 1 }
```
