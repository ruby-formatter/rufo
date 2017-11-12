---
title: "align\\_assignments"
permalink: "/examples/align_assignments/"
toc: true
sidebar:
  nav: "examples"
---

### unnamed 6
```ruby
# GIVEN
x = 1
 xyz = 2

 w = 3
```
```ruby
# BECOMES
x = 1
xyz = 2

w = 3
```
### unnamed 7
```ruby
# GIVEN
x = 1
 foo[bar] = 2

 w = 3
```
```ruby
# BECOMES
x = 1
foo[bar] = 2

w = 3
```
### unnamed 8
```ruby
# GIVEN
x = 1; x = 2
 xyz = 2

 w = 3
```
```ruby
# BECOMES
x = 1; x = 2
xyz = 2

w = 3
```
### unnamed 9
```ruby
# GIVEN
a = begin
 b = 1
 abc = 2
 end
```
```ruby
# BECOMES
a = begin
  b = 1
  abc = 2
end
```
### unnamed 10
```ruby
# GIVEN
a = 1
 a += 2
```
```ruby
# BECOMES
a = 1
a += 2
```
### unnamed 11
```ruby
# GIVEN
foo = 1
 a += 2
```
```ruby
# BECOMES
foo = 1
a += 2
```
### unnamed 12
```ruby
# GIVEN
x = 1
 xyz = 2

 w = 3
```
```ruby
# BECOMES
x = 1
xyz = 2

w = 3
```
