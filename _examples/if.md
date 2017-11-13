---
title: "if"
permalink: "/examples/if/"
toc: true
sidebar:
  nav: "examples"
---

### if 1
```ruby
# GIVEN
if 1
2
end
```
```ruby
# BECOMES
if 1
  2
end
```
### if 2
```ruby
# GIVEN
if 1

2

end
```
```ruby
# BECOMES
if 1
  2
end
```
### if 3
```ruby
# GIVEN
if 1

end
```
```ruby
# BECOMES
if 1
end
```
### if 4
```ruby
# GIVEN
if 1;end
```
```ruby
# BECOMES
if 1; end
```
### if 5
```ruby
# GIVEN
if 1 # hello
end
```
```ruby
# BECOMES
if 1 # hello
end
```
### if 6
```ruby
# GIVEN
if 1 # hello

end
```
```ruby
# BECOMES
if 1 # hello
end
```
### if 7
```ruby
# GIVEN
if 1 # hello
1
end
```
```ruby
# BECOMES
if 1 # hello
  1
end
```
### if 8
```ruby
# GIVEN
if 1;# hello
1
end
```
```ruby
# BECOMES
if 1 # hello
  1
end
```
### if 9
```ruby
# GIVEN
if 1 # hello
 # bye
end
```
```ruby
# BECOMES
if 1 # hello
  # bye
end
```
### if 10
```ruby
# GIVEN
if 1; 2; else; end
```
```ruby
# BECOMES
if 1; 2; else; end
```
### if 11
```ruby
# GIVEN
if 1; 2; else; 3; end
```
```ruby
# BECOMES
if 1; 2; else; 3; end
```
### if 12
```ruby
# GIVEN
if 1; 2; else # comment
 3; end
```
```ruby
# BECOMES
if 1; 2; else # comment
  3
end
```
### if 13
```ruby
# GIVEN
begin
if 1
2
else
3
end
end
```
```ruby
# BECOMES
begin
  if 1
    2
  else
    3
  end
end
```
### if 14
```ruby
# GIVEN
if 1 then 2 else 3 end
```
```ruby
# BECOMES
if 1 then 2 else 3 end
```
### if 15
```ruby
# GIVEN
if 1 
 2 
 elsif 3 
 4 
 end
```
```ruby
# BECOMES
if 1
  2
elsif 3
  4
end
```
### if 16
```ruby
# GIVEN
if 1
then 2
end
```
```ruby
# BECOMES
if 1
  2
end
```
