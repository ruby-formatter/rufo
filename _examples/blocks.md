---
title: "blocks"
permalink: "/examples/blocks/"
toc: true
sidebar:
  nav: "examples"
---

### blocks 1
```ruby
# GIVEN
foo   {}
```
```ruby
# BECOMES
foo { }
```
### blocks 2
```ruby
# GIVEN
foo   {   }
```
```ruby
# BECOMES
foo { }
```
### blocks 3
```ruby
# GIVEN
foo   {  1 }
```
```ruby
# BECOMES
foo { 1 }
```
### blocks 4
```ruby
# GIVEN
foo   {  1 ; 2 }
```
```ruby
# BECOMES
foo { 1; 2 }
```
### blocks 5
```ruby
# GIVEN
foo   {  1
 2 }
```
```ruby
# BECOMES
foo {
  1
  2
}
```
### blocks 6
```ruby
# GIVEN
foo {
  1 }
```
```ruby
# BECOMES
foo {
  1
}
```
### blocks 7
```ruby
# GIVEN
begin
 foo {  1  }
 end
```
```ruby
# BECOMES
begin
  foo { 1 }
end
```
### blocks 8
```ruby
# GIVEN
foo { | x , y | }
```
```ruby
# BECOMES
foo { |x, y| }
```
### blocks 9
```ruby
# GIVEN
foo { | x , | }
```
```ruby
# BECOMES
foo { |x, | }
```
### blocks 10
```ruby
# GIVEN
foo { | x , y, | bar}
```
```ruby
# BECOMES
foo { |x, y, | bar }
```
### blocks 11
```ruby
# GIVEN
foo { || }
```
```ruby
# BECOMES
foo { }
```
### blocks 12
```ruby
# GIVEN
foo { | | }
```
```ruby
# BECOMES
foo { }
```
### blocks 13
```ruby
# GIVEN
foo { | ( x ) , z | }
```
```ruby
# BECOMES
foo { |(x), z| }
```
### blocks 14
```ruby
# GIVEN
foo { | ( x , y ) , z | }
```
```ruby
# BECOMES
foo { |(x, y), z| }
```
### blocks 15
```ruby
# GIVEN
foo { | ( x , ( y , w ) ) , z | }
```
```ruby
# BECOMES
foo { |(x, (y, w)), z| }
```
### blocks 16
```ruby
# GIVEN
foo { | bar: 1 , baz: 2 | }
```
```ruby
# BECOMES
foo { |bar: 1, baz: 2| }
```
### blocks 17
```ruby
# GIVEN
foo { | *z | }
```
```ruby
# BECOMES
foo { |*z| }
```
### blocks 18
```ruby
# GIVEN
foo { | **z | }
```
```ruby
# BECOMES
foo { |**z| }
```
### blocks 19
```ruby
# GIVEN
foo { | bar = 1 | }
```
```ruby
# BECOMES
foo { |bar = 1| }
```
### blocks 20
```ruby
# GIVEN
foo { | x , y | 1 }
```
```ruby
# BECOMES
foo { |x, y| 1 }
```
### blocks 21
```ruby
# GIVEN
foo { | x |
  1 }
```
```ruby
# BECOMES
foo { |x|
  1
}
```
### blocks 22
```ruby
# GIVEN
foo { | x ,
 y |
  1 }
```
```ruby
# BECOMES
foo { |x,
       y|
  1
}
```
### blocks 23
```ruby
# GIVEN
foo   do   end
```
```ruby
# BECOMES
foo do end
```
### blocks 24
```ruby
# GIVEN
foo   do 1  end
```
```ruby
# BECOMES
foo do 1 end
```
### blocks 25
```ruby
# GIVEN
bar foo {
 1
 }, 2
```
```ruby
# BECOMES
bar foo {
  1
}, 2
```
### blocks 26
```ruby
# GIVEN
bar foo {
 1
 } + 2
```
```ruby
# BECOMES
bar foo {
  1
} + 2
```
### blocks 27
```ruby
# GIVEN
foo { |;x| }
```
```ruby
# BECOMES
foo { |; x| }
```
### blocks 28
```ruby
# GIVEN
foo { |
;x| }
```
```ruby
# BECOMES
foo { |; x| }
```
### blocks 29
```ruby
# GIVEN
foo { |;x, y| }
```
```ruby
# BECOMES
foo { |; x, y| }
```
### blocks 30
```ruby
# GIVEN
foo { |a, b;x, y| }
```
```ruby
# BECOMES
foo { |a, b; x, y| }
```
### blocks 31
```ruby
# GIVEN
proc { |(x, *y),z| }
```
```ruby
# BECOMES
proc { |(x, *y), z| }
```
### blocks 32
```ruby
# GIVEN
proc { |(w, *x, y), z| }
```
```ruby
# BECOMES
proc { |(w, *x, y), z| }
```
### blocks 33
```ruby
# GIVEN
foo { |(*x, y), z| }
```
```ruby
# BECOMES
foo { |(*x, y), z| }
```
### blocks 34
```ruby
# GIVEN
foo { begin; end; }
```
```ruby
# BECOMES
foo { begin; end }
```
### blocks 35
```ruby
# GIVEN
foo {
 |i| }
```
```ruby
# BECOMES
foo {
  |i| }
```
