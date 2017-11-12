---
title: "while"
permalink: "/examples/while/"
toc: true
sidebar:
  nav: "examples"
---

### unnamed 725
```ruby
# GIVEN
while 1 ; end
```
```ruby
# BECOMES
while 1; end
```
### unnamed 726
```ruby
# GIVEN
while 1 ; 2 ; end
```
```ruby
# BECOMES
while 1; 2; end
```
### unnamed 727
```ruby
# GIVEN
while 1
 end
```
```ruby
# BECOMES
while 1
end
```
### unnamed 728
```ruby
# GIVEN
while 1
 2
 3
 end
```
```ruby
# BECOMES
while 1
  2
  3
end
```
### unnamed 729
```ruby
# GIVEN
while 1  # foo
 2
 3
 end
```
```ruby
# BECOMES
while 1 # foo
  2
  3
end
```
### unnamed 730
```ruby
# GIVEN
while 1 do  end
```
```ruby
# BECOMES
while 1 do end
```
### unnamed 731
```ruby
# GIVEN
while 1 do  2  end
```
```ruby
# BECOMES
while 1 do 2 end
```
### unnamed 732
```ruby
# GIVEN
begin
 while 1  do  2  end
 end
```
```ruby
# BECOMES
begin
  while 1 do 2 end
end
```
