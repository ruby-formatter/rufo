---
title: "align\\_case\\_when"
permalink: "/examples/align_case_when/"
toc: true
sidebar:
  nav: "examples"
---

### align\_case\_when 1
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
### align\_case\_when 2
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
### align\_case\_when 3
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
### align\_case\_when 4
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
