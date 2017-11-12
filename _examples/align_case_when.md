---
title: "align\\_case\\_when"
permalink: "/examples/align_case_when/"
toc: true
sidebar:
  nav: "examples"
---

### unnamed 13
```ruby
# GIVEN
case
 when 1 then 2
 when 234 then 5 
 else 6
 end
```
```ruby
# BECOMES
case
when 1 then 2
when 234 then 5
else 6
end
```
```ruby
# with setting `align_case_when true`
case
when 1   then 2
when 234 then 5
else          6
end
```
### unnamed 14
```ruby
# GIVEN
case
 when 1; 2
 when 234; 5 
 end
```
```ruby
# BECOMES
case
when 1; 2
when 234; 5
end
```
```ruby
# with setting `align_case_when true`
case
when 1;   2
when 234; 5
end
```
### unnamed 15
```ruby
# GIVEN
case
 when 1; 2
 when 234; 5 
 else 6
 end
```
```ruby
# BECOMES
case
when 1; 2
when 234; 5
else 6
end
```
```ruby
# with setting `align_case_when true`
case
when 1;   2
when 234; 5
else      6
end
```
### unnamed 16
```ruby
# GIVEN
case
 when 1 then 2
 when 234 then 5 
 else 6 
 end
```
```ruby
# BECOMES
case
when 1 then 2
when 234 then 5
else 6
end
```
```ruby
# with setting `align_case_when true`
case
when 1   then 2
when 234 then 5
else          6
end
```
