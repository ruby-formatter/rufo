---
title: "binary\\_operators"
permalink: "/examples/binary_operators/"
toc: true
sidebar:
  nav: "examples"
---

### binary\_operators 1
```ruby
# GIVEN
1   +   2
```
```ruby
# BECOMES
1 + 2
```
### binary\_operators 2
```ruby
# GIVEN
1+2
```
```ruby
# BECOMES
1 + 2
```
### binary\_operators 3
```ruby
# GIVEN
1   +
 2
```
```ruby
# BECOMES
1 +
  2
```
### binary\_operators 4
```ruby
# GIVEN
1   +  # hello
 2
```
```ruby
# BECOMES
1 + # hello
  2
```
### binary\_operators 5
```ruby
# GIVEN
1 +
 2+
 3
```
```ruby
# BECOMES
1 +
  2 +
  3
```
### binary\_operators 6
```ruby
# GIVEN
1  &&  2
```
```ruby
# BECOMES
1 && 2
```
### binary\_operators 7
```ruby
# GIVEN
1  ||  2
```
```ruby
# BECOMES
1 || 2
```
### binary\_operators 8
```ruby
# GIVEN
1*2
```
```ruby
# BECOMES
1 * 2
```
### binary\_operators 9
```ruby
# GIVEN
1* 2
```
```ruby
# BECOMES
1 * 2
```
### binary\_operators 10
```ruby
# GIVEN
1 *2
```
```ruby
# BECOMES
1 * 2
```
### binary\_operators 11
```ruby
# GIVEN
1/2
```
```ruby
# BECOMES
1 / 2
```
### binary\_operators 12
```ruby
# GIVEN
1**2
```
```ruby
# BECOMES
1 ** 2
```
### binary\_operators 13
```ruby
# GIVEN
1 \
 + 2
```
```ruby
# BECOMES
1 \
  + 2
```
### binary\_operators 14
```ruby
# GIVEN
a = 1 ||
2
```
```ruby
# BECOMES
a = 1 ||
    2
```
### binary\_operators 15
```ruby
# GIVEN
1 ||
2
```
```ruby
# BECOMES
1 ||
2
```
