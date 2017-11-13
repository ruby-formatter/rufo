---
title: "lambdas"
permalink: "/examples/lambdas/"
toc: true
sidebar:
  nav: "examples"
---

### lambdas 1
```ruby
# GIVEN
-> { }
```
```ruby
# BECOMES
-> { }
```
### lambdas 2
```ruby
# GIVEN
->{ }
```
```ruby
# BECOMES
-> { }
```
### lambdas 3
```ruby
# GIVEN
->{   1   }
```
```ruby
# BECOMES
-> { 1 }
```
### lambdas 4
```ruby
# GIVEN
->{   1 ; 2  }
```
```ruby
# BECOMES
-> { 1; 2 }
```
### lambdas 5
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
### lambdas 6
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
### lambdas 7
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
### lambdas 8
```ruby
# GIVEN
->( x ){ }
```
```ruby
# BECOMES
-> (x) { }
```
