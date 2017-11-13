---
title: "END"
permalink: "/examples/END/"
toc: true
sidebar:
  nav: "examples"
---

### END 1
```ruby
# GIVEN
END  { 
 1 
 2 
 }
```
```ruby
# BECOMES
END {
  1
  2
}
```
### END 2
```ruby
# GIVEN
END  { 1 ; 2 }
```
```ruby
# BECOMES
END { 1; 2 }
```
