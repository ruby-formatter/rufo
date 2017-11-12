---
title: "semicolons"
permalink: "/examples/semicolons/"
toc: true
sidebar:
  nav: "examples"
---

### unnamed 574
```ruby
# GIVEN
123;
```
```ruby
# BECOMES
123
```
### unnamed 575
```ruby
# GIVEN
1   ;   2
```
```ruby
# BECOMES
1; 2
```
### unnamed 576
```ruby
# GIVEN
1   ;  ;   2
```
```ruby
# BECOMES
1; 2
```
### unnamed 577
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
### unnamed 578
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
### unnamed 579
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
### unnamed 580
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
### unnamed 581
```ruby
# GIVEN
123; # hello
```
```ruby
# BECOMES
123 # hello
```
### unnamed 582
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
### unnamed 583
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
