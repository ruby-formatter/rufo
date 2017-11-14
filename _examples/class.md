---
title: "class"
permalink: "/examples/class/"
toc: true
sidebar:
  nav: "examples"
---

### class 1
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
### class 2
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
### class 3
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
### class 4
```ruby
# GIVEN
class Foo  ;  end
```
```ruby
# BECOMES
class Foo; end
```
### class 5
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
### class 6
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
### class 7
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
### multi_inline_definitions
```ruby
# GIVEN
class A; end; class B; end
```
```ruby
# BECOMES
class A; end
class B; end
```
### multi_inline_definitions_with_comment
```ruby
# GIVEN
class A; end; class B; end; class C; end # comment
```
```ruby
# BECOMES
class A; end
class B; end
class C; end # comment
```
