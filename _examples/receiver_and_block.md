---
title: "receiver\\_and\\_block"
permalink: "/examples/receiver_and_block/"
toc: true
sidebar:
  nav: "examples"
---

### receiver\_and\_block 1
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
### receiver\_and\_block 2
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
