---
title: "align\\_assignments"
permalink: "/examples/align_assignments/"
toc: true
sidebar:
  nav: "examples"
---

### align\_assignments 1
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
### align\_assignments 2
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
### align\_assignments 3
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
### align\_assignments 4
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
### align\_assignments 5
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
### align\_assignments 6
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
### align\_assignments 7
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
