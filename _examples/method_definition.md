---
title: "method\\_definition"
permalink: "/examples/method_definition/"
toc: true
sidebar:
  nav: "examples"
---

### unnamed 462
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
### unnamed 463
```ruby
# GIVEN
def foo ; end
```
```ruby
# BECOMES
def foo; end
```
### unnamed 464
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
### unnamed 465
```ruby
# GIVEN
def foo() 1 end
```
```ruby
# BECOMES
def foo() 1 end
```
### unnamed 466
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
### unnamed 467
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
### unnamed 468
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
### unnamed 469
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
### unnamed 470
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
### unnamed 471
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
### unnamed 472
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
### unnamed 473
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
### unnamed 474
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
### unnamed 475
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
### unnamed 476
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
### unnamed 477
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
### unnamed 478
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
### unnamed 479
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
### unnamed 480
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
### unnamed 481
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
### unnamed 482
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
### unnamed 483
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
### unnamed 484
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
### unnamed 485
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
### unnamed 486
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
### unnamed 487
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
### unnamed 488
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
### unnamed 489
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
### unnamed 490
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
### unnamed 491
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
### unnamed 492
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
