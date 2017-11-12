---
title: "receiver\\_and\\_block"
permalink: "/examples/receiver_and_block/"
toc: true
sidebar:
  nav: "examples"
---

### unnamed 560
```ruby
# GIVEN
foo.bar 1 do 
 end
```
```ruby
# BECOMES
foo.bar 1 do
end
```
### unnamed 561
```ruby
# GIVEN
foo::bar 1 do 
 end
```
```ruby
# BECOMES
foo::bar 1 do
end
```
