---
title: "begin\\_rescue\\_end"
permalink: "/examples/begin_rescue_end/"
toc: true
sidebar:
  nav: "examples"
---

### begin\_rescue\_end 1
```ruby
# GIVEN
begin 
 1 
 rescue 
 2 
 end
```
```ruby
# BECOMES
begin
  1
rescue
  2
end
```
### begin\_rescue\_end 2
```ruby
# GIVEN
begin
rescue A
rescue B
end
```
```ruby
# BECOMES
begin
rescue A
rescue B
end
```
### begin\_rescue\_end 3
```ruby
# GIVEN
begin 
 1 
 rescue   Foo 
 2 
 end
```
```ruby
# BECOMES
begin
  1
rescue Foo
  2
end
```
### begin\_rescue\_end 4
```ruby
# GIVEN
begin 
 1 
 rescue  =>   ex  
 2 
 end
```
```ruby
# BECOMES
begin
  1
rescue => ex
  2
end
```
### begin\_rescue\_end 5
```ruby
# GIVEN
begin 
 1 
 rescue  Foo  =>  ex 
 2 
 end
```
```ruby
# BECOMES
begin
  1
rescue Foo => ex
  2
end
```
### begin\_rescue\_end 6
```ruby
# GIVEN
begin 
 1 
 rescue  Foo  , Bar , Baz =>  ex 
 2 
 end
```
```ruby
# BECOMES
begin
  1
rescue Foo, Bar, Baz => ex
  2
end
```
### begin\_rescue\_end 7
```ruby
# GIVEN
begin 
 1 
 rescue  Foo  , 
 Bar , 
 Baz =>  ex 
 2 
 end
```
```ruby
# BECOMES
begin
  1
rescue Foo,
       Bar,
       Baz => ex
  2
end
```
### begin\_rescue\_end 8
```ruby
# GIVEN
begin 
 1 
 ensure 
 2 
 end
```
```ruby
# BECOMES
begin
  1
ensure
  2
end
```
### begin\_rescue\_end 9
```ruby
# GIVEN
begin 
 1 
 else 
 2 
 end
```
```ruby
# BECOMES
begin
  1
else
  2
end
```
### begin\_rescue\_end 10
```ruby
# GIVEN
begin
  1
rescue *x
end
```
```ruby
# BECOMES
begin
  1
rescue *x
end
```
### begin\_rescue\_end 11
```ruby
# GIVEN
begin
  1
rescue *x, *y
end
```
```ruby
# BECOMES
begin
  1
rescue *x, *y
end
```
### begin\_rescue\_end 12
```ruby
# GIVEN
begin
  1
rescue *x, y, *z
end
```
```ruby
# BECOMES
begin
  1
rescue *x, y, *z
end
```
