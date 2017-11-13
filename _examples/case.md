---
title: "case"
permalink: "/examples/case/"
toc: true
sidebar:
  nav: "examples"
---

### case 1
```ruby
# GIVEN
case
 when 1 then 2
 end
```
```ruby
# BECOMES
case
when 1 then 2
end
```
### case 2
```ruby
# GIVEN
case
 when 1 then 2
 when 3 then 4
 end
```
```ruby
# BECOMES
case
when 1 then 2
when 3 then 4
end
```
### case 3
```ruby
# GIVEN
case
 when 1 then 2 else 3
 end
```
```ruby
# BECOMES
case
when 1 then 2
else 3
end
```
```ruby
# with setting `align_case_when true`
case
when 1 then 2
else        3
end
```
### case 4
```ruby
# GIVEN
case
 when 1 ; 2
 end
```
```ruby
# BECOMES
case
when 1; 2
end
```
### case 5
```ruby
# GIVEN
case
 when 1
 2
 end
```
```ruby
# BECOMES
case
when 1
  2
end
```
### case 6
```ruby
# GIVEN
case
 when 1
 2
 3
 end
```
```ruby
# BECOMES
case
when 1
  2
  3
end
```
### case 7
```ruby
# GIVEN
case
 when 1
 2
 3
 when 4
 5
 end
```
```ruby
# BECOMES
case
when 1
  2
  3
when 4
  5
end
```
### case 8
```ruby
# GIVEN
case 123
 when 1
 2
 end
```
```ruby
# BECOMES
case 123
when 1
  2
end
```
### case 9
```ruby
# GIVEN
case  # foo
 when 1
 2
 end
```
```ruby
# BECOMES
case  # foo
when 1
  2
end
```
### case 10
```ruby
# GIVEN
case
 when 1  # comment
 2
 end
```
```ruby
# BECOMES
case
when 1 # comment
  2
end
```
### case 11
```ruby
# GIVEN
case
 when 1 then 2 else
 3
 end
```
```ruby
# BECOMES
case
when 1 then 2
else
  3
end
```
### case 12
```ruby
# GIVEN
case
 when 1 then 2 else ;
 3
 end
```
```ruby
# BECOMES
case
when 1 then 2
else
  3
end
```
### case 13
```ruby
# GIVEN
case
 when 1 then 2 else  # comm
 3
 end
```
```ruby
# BECOMES
case
when 1 then 2
else # comm
  3
end
```
### case 14
```ruby
# GIVEN
begin
 case
 when 1
 2
 when 3
 4
  else
 5
 end
 end
```
```ruby
# BECOMES
begin
  case
  when 1
    2
  when 3
    4
  else
    5
  end
end
```
### case 15
```ruby
# GIVEN
case
 when 1 then
 2
 end
```
```ruby
# BECOMES
case
when 1
  2
end
```
### case 16
```ruby
# GIVEN
case
 when 1 then ;
 2
 end
```
```ruby
# BECOMES
case
when 1
  2
end
```
### case 17
```ruby
# GIVEN
case
 when 1 ;
 2
 end
```
```ruby
# BECOMES
case
when 1
  2
end
```
### case 18
```ruby
# GIVEN
case
 when 1 ,
 2 ;
 3
 end
```
```ruby
# BECOMES
case
when 1,
     2
  3
end
```
### case 19
```ruby
# GIVEN
case
 when 1 , 2,  # comm

 3
 end
```
```ruby
# BECOMES
case
when 1, 2,  # comm
     3
end
```
### case 20
```ruby
# GIVEN
begin
 case
 when :x
 # comment
 2
 end
 end
```
```ruby
# BECOMES
begin
  case
  when :x
    # comment
    2
  end
end
```
### case 21
```ruby
# GIVEN
case 1
 when *x , *y
 2
 end
```
```ruby
# BECOMES
case 1
when *x, *y
  2
end
```
### case 22
```ruby
# GIVEN
case 1
when *x then 2
end
```
```ruby
# BECOMES
case 1
when *x then 2
end
```
### case 23
```ruby
# GIVEN
case 1
when  2  then  3
end
```
```ruby
# BECOMES
case 1
when 2 then 3
end
```
### case 24
```ruby
# GIVEN
case 1
when 2 then # comment
end
```
```ruby
# BECOMES
case 1
when 2 then # comment
end
```
### case 25
```ruby
# GIVEN
case 1
 when 2 then 3
 else
  4
end
```
```ruby
# BECOMES
case 1
when 2 then 3
else
  4
end
```
