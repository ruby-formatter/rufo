---
title: "lambdas"
permalink: "/examples/lambdas/"
toc: true
sidebar:
  nav: "examples"
---

### unnamed 388
```ruby
# GIVEN
-> { }
```
```ruby
# BECOMES
-> { }
```
### unnamed 389
```ruby
# GIVEN
->{ }
```
```ruby
# BECOMES
-> { }
```
### unnamed 390
```ruby
# GIVEN
->{   1   }
```
```ruby
# BECOMES
-> { 1 }
```
### unnamed 391
```ruby
# GIVEN
->{   1 ; 2  }
```
```ruby
# BECOMES
-> { 1; 2 }
```
### unnamed 392
```ruby
# GIVEN
->{   1
 2  }
```
```ruby
# BECOMES
-> {
  1
  2
}
```
### unnamed 393
```ruby
# GIVEN
-> do  1
 2  end
```
```ruby
# BECOMES
-> do
  1
  2
end
```
### unnamed 394
```ruby
# GIVEN
->do  1
 2  end
```
```ruby
# BECOMES
-> do
  1
  2
end
```
### unnamed 395
```ruby
# GIVEN
->( x ){ }
```
```ruby
# BECOMES
-> (x) { }
```
