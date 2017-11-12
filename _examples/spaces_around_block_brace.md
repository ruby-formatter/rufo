---
title: "spaces\\_around\\_block\\_brace"
permalink: "/examples/spaces_around_block_brace/"
toc: true
sidebar:
  nav: "examples"
---

### unnamed 601
```ruby
# GIVEN
foo{1}
```
```ruby
# BECOMES
foo { 1 }
```
### unnamed 602
```ruby
# GIVEN
foo{|x|1}
```
```ruby
# BECOMES
foo { |x| 1 }
```
### unnamed 603
```ruby
# GIVEN
foo  {  1  }
```
```ruby
# BECOMES
foo { 1 }
```
### unnamed 604
```ruby
# GIVEN
->{1}
```
```ruby
# BECOMES
-> { 1 }
```
