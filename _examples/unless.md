---
title: "unless"
permalink: "/examples/unless/"
toc: true
sidebar:
  nav: "examples"
---

### unless 1
```ruby
# GIVEN
unless 1
2
end
```
```ruby
# BECOMES
unless 1
  2
end
```
### unless 2
```ruby
# GIVEN
unless 1
2
else
end
```
```ruby
# BECOMES
unless 1
  2
else
end
```
