---
title: "multiple\\_assignments"
permalink: "/examples/multiple_assignments/"
toc: true
sidebar:
  nav: "examples"
---

### unnamed 502
```ruby
# GIVEN
a  =   1  ,   2
```
```ruby
# BECOMES
a = 1, 2
```
### unnamed 503
```ruby
# GIVEN
a , b  = 2
```
```ruby
# BECOMES
a, b = 2
```
### unnamed 504
```ruby
# GIVEN
a , b, ( c, d )  = 2
```
```ruby
# BECOMES
a, b, (c, d) = 2
```
### unnamed 505
```ruby
# GIVEN
*x = 1
```
```ruby
# BECOMES
*x = 1
```
### unnamed 506
```ruby
# GIVEN
a , b , *x = 1
```
```ruby
# BECOMES
a, b, *x = 1
```
### unnamed 507
```ruby
# GIVEN
*x , a , b = 1
```
```ruby
# BECOMES
*x, a, b = 1
```
### unnamed 508
```ruby
# GIVEN
a, b, *x, c, d = 1
```
```ruby
# BECOMES
a, b, *x, c, d = 1
```
### unnamed 509
```ruby
# GIVEN
a, b, = 1
```
```ruby
# BECOMES
a, b, = 1
```
### unnamed 510
```ruby
# GIVEN
a = b, *c
```
```ruby
# BECOMES
a = b, *c
```
### unnamed 511
```ruby
# GIVEN
a = b, *c, *d
```
```ruby
# BECOMES
a = b, *c, *d
```
### unnamed 512
```ruby
# GIVEN
a, = b
```
```ruby
# BECOMES
a, = b
```
### unnamed 513
```ruby
# GIVEN
a = b, c, *d
```
```ruby
# BECOMES
a = b, c, *d
```
### unnamed 514
```ruby
# GIVEN
a = b, c, *d, e
```
```ruby
# BECOMES
a = b, c, *d, e
```
### unnamed 515
```ruby
# GIVEN
*, y = z
```
```ruby
# BECOMES
*, y = z
```
### unnamed 516
```ruby
# GIVEN
w, (x,), y = z
```
```ruby
# BECOMES
w, (x,), y = z
```
### unnamed 517
```ruby
# GIVEN
a, b=1, 2
```
```ruby
# BECOMES
a, b = 1, 2
```
### unnamed 518
```ruby
# GIVEN
* = 1
```
```ruby
# BECOMES
* = 1
```
