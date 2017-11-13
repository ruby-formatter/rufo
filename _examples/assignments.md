---
title: "assignments"
permalink: "/examples/assignments/"
toc: true
sidebar:
  nav: "examples"
---

### assignments 1
```ruby
# GIVEN
a   =   1
```
```ruby
# BECOMES
a = 1
```
### assignments 2
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
### assignments 3
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
### assignments 4
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
### assignments 5
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
### assignments 6
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
### assignments 7
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
### assignments 8
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
### assignments 9
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
### assignments 10
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
### assignments 11
```ruby
# GIVEN
a=1
```
```ruby
# BECOMES
a = 1
```
### assignments 12
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
