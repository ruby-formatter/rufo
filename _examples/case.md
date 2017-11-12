---
title: "case"
permalink: "/examples/case/"
toc: true
sidebar:
  nav: "examples"
---

### unnamed 254
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
### unnamed 255
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
### unnamed 256
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
### unnamed 257
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
### unnamed 258
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
### unnamed 259
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
### unnamed 260
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
### unnamed 261
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
### unnamed 262
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
### unnamed 263
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
### unnamed 264
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
### unnamed 265
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
### unnamed 266
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
### unnamed 267
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
### unnamed 268
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
### unnamed 269
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
### unnamed 270
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
### unnamed 271
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
### unnamed 272
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
### unnamed 273
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
### unnamed 274
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
### unnamed 275
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
### unnamed 276
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
### unnamed 277
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
### unnamed 278
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
