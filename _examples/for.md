---
title: "for"
permalink: "/examples/for/"
toc: true
sidebar:
  nav: "examples"
---

### for 1
```ruby
# GIVEN
for  x  in  y
 2
 end
```
```ruby
# BECOMES
for x in y
  2
end
```
### for 2
```ruby
# GIVEN
for  x , y  in  z
 2
 end
```
```ruby
# BECOMES
for x, y in z
  2
end
```
### for 3
```ruby
# GIVEN
for  x  in  y  do
 2
 end
```
```ruby
# BECOMES
for x in y
  2
end
```
### bug_45
```ruby
# GIVEN
for i, in [[1,2]]
  i.should == 1
end
```
```ruby
# BECOMES
for i, in [[1, 2]]
  i.should == 1
end
```
### for 5
```ruby
# GIVEN
for i,j, in [[1,2]]
  i.should == 1
end
```
```ruby
# BECOMES
for i, j, in [[1, 2]]
  i.should == 1
end
```
