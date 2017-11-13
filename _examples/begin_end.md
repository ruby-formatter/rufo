---
title: "begin\\_end"
permalink: "/examples/begin_end/"
toc: true
sidebar:
  nav: "examples"
---

### begin\_end 1
```ruby
# GIVEN
begin;end
```
```ruby
# BECOMES
begin; end
```
### begin\_end 2
```ruby
# GIVEN
begin 
 end
```
```ruby
# BECOMES
begin
end
```
### begin\_end 3
```ruby
# GIVEN
begin 1 end
```
```ruby
# BECOMES
begin 1 end
```
### begin\_end 4
```ruby
# GIVEN
begin; 1; end
```
```ruby
# BECOMES
begin; 1; end
```
### begin\_end 5
```ruby
# GIVEN
begin; 1; 2; end
```
```ruby
# BECOMES
begin; 1; 2; end
```
### begin\_end 6
```ruby
# GIVEN
begin; 1 
 2; end
```
```ruby
# BECOMES
begin; 1
  2; end
```
### begin\_end 7
```ruby
# GIVEN
begin
 1 
 end
```
```ruby
# BECOMES
begin
  1
end
```
### begin\_end 8
```ruby
# GIVEN
begin
 1 
 2 
 end
```
```ruby
# BECOMES
begin
  1
  2
end
```
### begin\_end 9
```ruby
# GIVEN
begin 
 begin 
 1 
 end 
 2 
 end
```
```ruby
# BECOMES
begin
  begin
    1
  end
  2
end
```
### begin\_end 10
```ruby
# GIVEN
begin # hello
 end
```
```ruby
# BECOMES
begin # hello
end
```
### begin\_end 11
```ruby
# GIVEN
begin;# hello
 end
```
```ruby
# BECOMES
begin # hello
end
```
### begin\_end 12
```ruby
# GIVEN
begin
 1  # a
end
```
```ruby
# BECOMES
begin
  1  # a
end
```
### begin\_end 13
```ruby
# GIVEN
begin
 1  # a
 # b 
 3 # c 
 end
```
```ruby
# BECOMES
begin
  1  # a
  # b
  3 # c
end
```
### begin\_end 14
```ruby
# GIVEN
begin
end

# foo
```
```ruby
# BECOMES
begin
end

# foo
```
### begin\_end 15
```ruby
# GIVEN
begin
  begin 1 end
end
```
```ruby
# BECOMES
begin
  begin 1 end
end
```
### begin\_end 16
```ruby
# GIVEN
begin
  def foo(x) 1 end
end
```
```ruby
# BECOMES
begin
  def foo(x) 1 end
end
```
### begin\_end 17
```ruby
# GIVEN
begin
  if 1 then 2 end
end
```
```ruby
# BECOMES
begin
  if 1 then 2 end
end
```
### begin\_end 18
```ruby
# GIVEN
begin
  if 1 then 2 end
end
```
```ruby
# BECOMES
begin
  if 1 then 2 end
end
```
### begin\_end 19
```ruby
# GIVEN
begin
  foo do 1 end
end
```
```ruby
# BECOMES
begin
  foo do 1 end
end
```
### begin\_end 20
```ruby
# GIVEN
begin
  for x in y do 1 end
end
```
```ruby
# BECOMES
begin
  for x in y do 1 end
end
```
### begin\_end 21
```ruby
# GIVEN
begin
  # foo

  1
end
```
```ruby
# BECOMES
begin
  # foo

  1
end
```
