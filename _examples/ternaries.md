---
title: "ternaries"
permalink: "/examples/ternaries/"
toc: true
sidebar:
  nav: "examples"
---

### unnamed 674
```ruby
# GIVEN
1  ?   2    :  3
```
```ruby
# BECOMES
1 ? 2 : 3
```
### unnamed 675
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
### unnamed 676
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
### unnamed 677
```ruby
# GIVEN
1?2:3
```
```ruby
# BECOMES
1 ? 2 : 3
```
