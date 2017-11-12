---
title: "assignments"
permalink: "/examples/assignments/"
toc: true
sidebar:
  nav: "examples"
---

### unnamed 119
```ruby
# GIVEN
a   =   1
```
```ruby
# BECOMES
a = 1
```
### unnamed 120
```ruby
# GIVEN
a   =
2
```
```ruby
# BECOMES
a =
  2
```
### unnamed 121
```ruby
# GIVEN
a   =   # hello
2
```
```ruby
# BECOMES
a = # hello
  2
```
### unnamed 122
```ruby
# GIVEN
a = if 1
 2
 end
```
```ruby
# BECOMES
a = if 1
      2
    end
```
### unnamed 123
```ruby
# GIVEN
a = unless 1
 2
 end
```
```ruby
# BECOMES
a = unless 1
      2
    end
```
### unnamed 124
```ruby
# GIVEN
a = begin
1
 end
```
```ruby
# BECOMES
a = begin
  1
end
```
### unnamed 125
```ruby
# GIVEN
a = case
 when 1
 2
 end
```
```ruby
# BECOMES
a = case
    when 1
      2
    end
```
### unnamed 126
```ruby
# GIVEN
a = begin
1
end
```
```ruby
# BECOMES
a = begin
  1
end
```
### unnamed 127
```ruby
# GIVEN
a = begin
1
rescue
2
end
```
```ruby
# BECOMES
a = begin
      1
    rescue
      2
    end
```
### unnamed 128
```ruby
# GIVEN
a = begin
1
ensure
2
end
```
```ruby
# BECOMES
a = begin
      1
    ensure
      2
    end
```
### unnamed 129
```ruby
# GIVEN
a=1
```
```ruby
# BECOMES
a = 1
```
### unnamed 130
```ruby
# GIVEN
a = \
  begin
    1
  end
```
```ruby
# BECOMES
a =
  begin
    1
  end
```
