---
title: "begin\\_end"
permalink: "/examples/begin_end/"
toc: true
sidebar:
  nav: "examples"
---

### unnamed 135
```ruby
# GIVEN
begin;end
```
```ruby
# BECOMES
begin; end
```
### unnamed 136
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
### unnamed 137
```ruby
# GIVEN
begin 1 end
```
```ruby
# BECOMES
begin 1 end
```
### unnamed 138
```ruby
# GIVEN
begin; 1; end
```
```ruby
# BECOMES
begin; 1; end
```
### unnamed 139
```ruby
# GIVEN
begin; 1; 2; end
```
```ruby
# BECOMES
begin; 1; 2; end
```
### unnamed 140
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
### unnamed 141
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
### unnamed 142
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
### unnamed 143
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
### unnamed 144
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
### unnamed 145
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
### unnamed 146
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
### unnamed 147
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
### unnamed 148
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
### unnamed 149
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
### unnamed 150
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
### unnamed 151
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
### unnamed 152
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
### unnamed 153
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
### unnamed 154
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
### unnamed 155
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
