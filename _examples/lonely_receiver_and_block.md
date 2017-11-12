---
title: "lonely\\_receiver\\_and\\_block (v2.3 +)"
permalink: "/examples/lonely_receiver_and_block/"
toc: true
sidebar:
  nav: "examples"
---

### unnamed 741
```ruby
# GIVEN
foo&.bar 1 do 
 end
```
```ruby
# BECOMES
foo&.bar 1 do
end
```
