---
title: "semicolons"
permalink: "/examples/semicolons/"
toc: true
sidebar:
  nav: "examples"
---

### semicolons 1
```ruby
# GIVEN
123;
```
```ruby
# BECOMES
123
```
### semicolons 2
```ruby
# GIVEN
1   ;   2
```
```ruby
# BECOMES
1; 2
```
### semicolons 3
```ruby
# GIVEN
1   ;  ;   2
```
```ruby
# BECOMES
1; 2
```
### semicolons 4
```ruby
# GIVEN
1  
  2
```
```ruby
# BECOMES
1
2
```
### semicolons 5
```ruby
# GIVEN
1  
   
  2
```
```ruby
# BECOMES
1

2
```
### semicolons 6
```ruby
# GIVEN
1  
 ; ; ; 
  2
```
```ruby
# BECOMES
1

2
```
### semicolons 7
```ruby
# GIVEN
1 ; 
 ; 
 ; ; 
  2
```
```ruby
# BECOMES
1

2
```
### semicolons 8
```ruby
# GIVEN
123; # hello
```
```ruby
# BECOMES
123 # hello
```
### semicolons 9
```ruby
# GIVEN
1;
2
```
```ruby
# BECOMES
1
2
```
### semicolons 10
```ruby
# GIVEN
begin
 1 ; 2 
 end
```
```ruby
# BECOMES
begin
  1; 2
end
```
