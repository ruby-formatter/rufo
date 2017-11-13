---
title: "BEGIN"
permalink: "/examples/BEGIN/"
toc: true
sidebar:
  nav: "examples"
---

### BEGIN 1
```ruby
# GIVEN
BEGIN  { 
 1 
 2 
 }
```
```ruby
# BECOMES
BEGIN {
  1
  2
}
```
### BEGIN 2
```ruby
# GIVEN
BEGIN  { 1 ; 2 }
```
```ruby
# BECOMES
BEGIN { 1; 2 }
```
