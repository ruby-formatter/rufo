---
title: "suffix\\_rescue"
permalink: "/examples/suffix_rescue/"
toc: true
sidebar:
  nav: "examples"
---

### unnamed 661
```ruby
# GIVEN
URI(string) rescue return
```
```ruby
# BECOMES
URI(string) rescue return
```
### unnamed 662
```ruby
# GIVEN
URI(string) while return
```
```ruby
# BECOMES
URI(string) while return
```
### unnamed 663
```ruby
# GIVEN
URI(string) if return
```
```ruby
# BECOMES
URI(string) if return
```
### unnamed 664
```ruby
# GIVEN
URI(string) unless return
```
```ruby
# BECOMES
URI(string) unless return
```
