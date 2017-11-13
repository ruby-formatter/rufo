---
title: "suffix\\_rescue"
permalink: "/examples/suffix_rescue/"
toc: true
sidebar:
  nav: "examples"
---

### suffix\_rescue 1
```ruby
# GIVEN
URI(string) rescue return
```
```ruby
# BECOMES
URI(string) rescue return
```
### suffix\_rescue 2
```ruby
# GIVEN
URI(string) while return
```
```ruby
# BECOMES
URI(string) while return
```
### suffix\_rescue 3
```ruby
# GIVEN
URI(string) if return
```
```ruby
# BECOMES
URI(string) if return
```
### suffix\_rescue 4
```ruby
# GIVEN
URI(string) unless return
```
```ruby
# BECOMES
URI(string) unless return
```
