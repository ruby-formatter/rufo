---
title: "class"
permalink: "/examples/class/"
toc: true
sidebar:
  nav: "examples"
---

### unnamed 280
```ruby
# GIVEN
class   Foo  
  end
```
```ruby
# BECOMES
class Foo
end
```
### unnamed 281
```ruby
# GIVEN
class   Foo  < Bar 
  end
```
```ruby
# BECOMES
class Foo < Bar
end
```
### unnamed 282
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
### unnamed 283
```ruby
# GIVEN
class Foo  ;  end
```
```ruby
# BECOMES
class Foo; end
```
### unnamed 284
```ruby
# GIVEN
class Foo; 
  end
```
```ruby
# BECOMES
class Foo
end
```
### unnamed 285
```ruby
# GIVEN
class Foo; 1; end
class Bar; 2; end
```
```ruby
# BECOMES
class Foo; 1; end
class Bar; 2; end
```
### unnamed 286
```ruby
# GIVEN
class Foo; 1; end

class Bar; 2; end
```
```ruby
# BECOMES
class Foo; 1; end

class Bar; 2; end
```
