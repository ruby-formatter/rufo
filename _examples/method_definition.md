---
title: "method\\_definition"
permalink: "/examples/method_definition/"
toc: true
sidebar:
  nav: "examples"
---

### method\_definition 1
```ruby
# GIVEN
def foo
 end
```
```ruby
# BECOMES
def foo
end
```
### method\_definition 2
```ruby
# GIVEN
def foo ; end
```
```ruby
# BECOMES
def foo; end
```
### method\_definition 3
```ruby
# GIVEN
def foo()
 end
```
```ruby
# BECOMES
def foo()
end
```
### method\_definition 4
```ruby
# GIVEN
def foo() 1 end
```
```ruby
# BECOMES
def foo() 1 end
```
### method\_definition 5
```ruby
# GIVEN
def foo(
 )
 end
```
```ruby
# BECOMES
def foo()
end
```
### method\_definition 6
```ruby
# GIVEN
def foo( x )
 end
```
```ruby
# BECOMES
def foo(x)
end
```
### method\_definition 7
```ruby
# GIVEN
def foo( x , y )
 end
```
```ruby
# BECOMES
def foo(x, y)
end
```
### method\_definition 8
```ruby
# GIVEN
def foo x
 end
```
```ruby
# BECOMES
def foo(x)
end
```
```ruby
# with setting `parens_in_def :dynamic`
def foo x
end
```
### method\_definition 9
```ruby
# GIVEN
def foo x , y
 end
```
```ruby
# BECOMES
def foo(x, y)
end
```
```ruby
# with setting `parens_in_def :dynamic`
def foo x, y
end
```
### method\_definition 10
```ruby
# GIVEN
def foo
 1
 end
```
```ruby
# BECOMES
def foo
  1
end
```
### method\_definition 11
```ruby
# GIVEN
def foo( * x )
 1
 end
```
```ruby
# BECOMES
def foo(*x)
  1
end
```
### method\_definition 12
```ruby
# GIVEN
def foo( a , * x )
 1
 end
```
```ruby
# BECOMES
def foo(a, *x)
  1
end
```
### method\_definition 13
```ruby
# GIVEN
def foo( a , * x, b )
 1
 end
```
```ruby
# BECOMES
def foo(a, *x, b)
  1
end
```
### method\_definition 14
```ruby
# GIVEN
def foo( x  =  1 )
 end
```
```ruby
# BECOMES
def foo(x = 1)
end
```
### method\_definition 15
```ruby
# GIVEN
def foo( x  =  1, * y )
 end
```
```ruby
# BECOMES
def foo(x = 1, *y)
end
```
### method\_definition 16
```ruby
# GIVEN
def foo( & block )
 end
```
```ruby
# BECOMES
def foo(&block)
end
```
### method\_definition 17
```ruby
# GIVEN
def foo( a: , b: )
 end
```
```ruby
# BECOMES
def foo(a:, b:)
end
```
### method\_definition 18
```ruby
# GIVEN
def foo( a: 1 , b: 2  )
 end
```
```ruby
# BECOMES
def foo(a: 1, b: 2)
end
```
### method\_definition 19
```ruby
# GIVEN
def foo( x,
 y )
 end
```
```ruby
# BECOMES
def foo(x,
        y)
end
```
### method\_definition 20
```ruby
# GIVEN
def foo( a: 1,
 b: 2 )
 end
```
```ruby
# BECOMES
def foo(a: 1,
        b: 2)
end
```
### method\_definition 21
```ruby
# GIVEN
def foo(
 x,
 y )
 end
```
```ruby
# BECOMES
def foo(
        x,
        y)
end
```
### method\_definition 22
```ruby
# GIVEN
def foo( a: 1, &block )
 end
```
```ruby
# BECOMES
def foo(a: 1, &block)
end
```
### method\_definition 23
```ruby
# GIVEN
def foo( a: 1,
 &block )
 end
```
```ruby
# BECOMES
def foo(a: 1,
        &block)
end
```
### method\_definition 24
```ruby
# GIVEN
def foo(*)
 end
```
```ruby
# BECOMES
def foo(*)
end
```
### method\_definition 25
```ruby
# GIVEN
def foo(**)
 end
```
```ruby
# BECOMES
def foo(**)
end
```
### method\_definition 26
```ruby
# GIVEN
def `(cmd)
end
```
```ruby
# BECOMES
def `(cmd)
end
```
### method\_definition 27
```ruby
# GIVEN
module_function def foo
  1
end
```
```ruby
# BECOMES
module_function def foo
  1
end
```
### method\_definition 28
```ruby
# GIVEN
private def foo
  1
end
```
```ruby
# BECOMES
private def foo
  1
end
```
### method\_definition 29
```ruby
# GIVEN
some class Foo
  1
end
```
```ruby
# BECOMES
some class Foo
  1
end
```
### method\_definition 30
```ruby
# GIVEN
def foo; 1; end
def bar; 2; end
```
```ruby
# BECOMES
def foo; 1; end
def bar; 2; end
```
### method\_definition 31
```ruby
# GIVEN
def foo; 1; end

def bar; 2; end
```
```ruby
# BECOMES
def foo; 1; end

def bar; 2; end
```
