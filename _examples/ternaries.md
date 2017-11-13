---
title: "ternaries"
permalink: "/examples/ternaries/"
toc: true
sidebar:
  nav: "examples"
---

### ternaries 1
```ruby
# GIVEN
1  ?   2    :  3
```
```ruby
# BECOMES
1 ? 2 : 3
```
### ternaries 2
```ruby
# GIVEN
1 ?
 2 : 3
```
```ruby
# BECOMES
1 ?
  2 : 3
```
### ternaries 3
```ruby
# GIVEN
1 ? 2 :
 3
```
```ruby
# BECOMES
1 ? 2 :
  3
```
### ternaries 4
```ruby
# GIVEN
1?2:3
```
```ruby
# BECOMES
1 ? 2 : 3
```
