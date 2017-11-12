---
title: "if"
permalink: "/examples/if/"
toc: true
sidebar:
  nav: "examples"
---

### unnamed 365
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
### unnamed 366
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
### unnamed 367
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
### unnamed 368
```ruby
# GIVEN
if 1;end
```
```ruby
# BECOMES
if 1; end
```
### unnamed 369
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
### unnamed 370
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
### unnamed 371
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
### unnamed 372
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
### unnamed 373
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
### unnamed 374
```ruby
# GIVEN
if 1; 2; else; end
```
```ruby
# BECOMES
if 1; 2; else; end
```
### unnamed 375
```ruby
# GIVEN
if 1; 2; else; 3; end
```
```ruby
# BECOMES
if 1; 2; else; 3; end
```
### unnamed 376
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
### unnamed 377
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
### unnamed 378
```ruby
# GIVEN
if 1 then 2 else 3 end
```
```ruby
# BECOMES
if 1 then 2 else 3 end
```
### unnamed 379
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
### unnamed 380
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
