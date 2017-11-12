---
title: "double\\_newline\\_inside\\_type"
permalink: "/examples/double_newline_inside_type/"
toc: true
sidebar:
  nav: "examples"
---

### unnamed 321
```ruby
# GIVEN
class Foo

1

end
```
```ruby
# BECOMES
class Foo
  1
end
```
### unnamed 322
```ruby
# GIVEN
class Foo


1


end
```
```ruby
# BECOMES
class Foo
  1
end
```
