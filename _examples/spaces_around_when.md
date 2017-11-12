---
title: "spaces\\_around\\_when"
permalink: "/examples/spaces_around_when/"
toc: true
sidebar:
  nav: "examples"
---

### unnamed 620
```ruby
# GIVEN
case 1
when  2  then  3
else  4
end
```
```ruby
# BECOMES
case 1
when 2 then 3
else 4
end
```
```ruby
# with setting `align_case_when true`
case 1
when 2 then 3
else        4
end
```
