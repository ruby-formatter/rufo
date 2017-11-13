---
title: "yield"
permalink: "/examples/yield/"
toc: true
sidebar:
  nav: "examples"
---

### yield
```ruby
# GIVEN
yield
```
```ruby
# BECOMES
yield
```
### yield 2
```ruby
# GIVEN
yield  1
```
```ruby
# BECOMES
yield 1
```
### yield 3
```ruby
# GIVEN
yield  1 , 2
```
```ruby
# BECOMES
yield 1, 2
```
### yield 4
```ruby
# GIVEN
yield  1 , 
 2
```
```ruby
# BECOMES
yield 1,
      2
```
### yield 5
```ruby
# GIVEN
yield( 1 , 2 )
```
```ruby
# BECOMES
yield(1, 2)
```
