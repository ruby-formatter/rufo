---
title: "double\\_newline\\_inside\\_type"
permalink: "/examples/double_newline_inside_type/"
toc: true
sidebar:
  nav: "examples"
---

### double\_newline\_inside\_type 1
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
### double\_newline\_inside\_type 2
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
