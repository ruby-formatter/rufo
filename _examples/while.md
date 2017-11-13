---
title: "while"
permalink: "/examples/while/"
toc: true
sidebar:
  nav: "examples"
---

### while 1
```ruby
# GIVEN
while 1 ; end
```
```ruby
# BECOMES
while 1; end
```
### while 2
```ruby
# GIVEN
while 1 ; 2 ; end
```
```ruby
# BECOMES
while 1; 2; end
```
### while 3
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
### while 4
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
### while 5
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
### while 6
```ruby
# GIVEN
while 1 do  end
```
```ruby
# BECOMES
while 1 do end
```
### while 7
```ruby
# GIVEN
while 1 do  2  end
```
```ruby
# BECOMES
while 1 do 2 end
```
### while 8
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
