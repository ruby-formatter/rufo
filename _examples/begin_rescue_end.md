---
title: "begin\\_rescue\\_end"
permalink: "/examples/begin_rescue_end/"
toc: true
sidebar:
  nav: "examples"
---

### unnamed 156
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
### unnamed 157
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
### unnamed 158
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
### unnamed 159
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
### unnamed 160
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
### unnamed 161
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
### unnamed 162
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
### unnamed 163
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
### unnamed 164
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
### unnamed 165
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
### unnamed 166
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
### unnamed 167
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
