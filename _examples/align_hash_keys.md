---
title: "align\\_hash\\_keys"
permalink: "/examples/align_hash_keys/"
toc: true
sidebar:
  nav: "examples"
---

### unnamed 52
```ruby
# GIVEN
{
 1 => 2,
 123 => 4 }
```
```ruby
# BECOMES
{
  1 => 2,
  123 => 4,
}
```
```ruby
# with setting `trailing_commas false`
{
  1 => 2,
  123 => 4
}
```
### unnamed 53
```ruby
# GIVEN
{
 foo: 1,
 barbaz: 2 }
```
```ruby
# BECOMES
{
  foo: 1,
  barbaz: 2,
}
```
```ruby
# with setting `trailing_commas false`
{
  foo: 1,
  barbaz: 2
}
```
### unnamed 54
```ruby
# GIVEN
foo bar: 1,
 barbaz: 2
```
```ruby
# BECOMES
foo bar: 1,
    barbaz: 2
```
### unnamed 55
```ruby
# GIVEN
foo(
  bar: 1,
 barbaz: 2)
```
```ruby
# BECOMES
foo(
  bar: 1,
  barbaz: 2,
)
```
```ruby
# with setting `trailing_commas false`
foo(
  bar: 1,
  barbaz: 2
)
```
### unnamed 56
```ruby
# GIVEN
def foo(x,
 y: 1,
 bar: 2)
end
```
```ruby
# BECOMES
def foo(x,
        y: 1,
        bar: 2)
end
```
### unnamed 57
```ruby
# GIVEN
{1 => 2}
{123 => 4}
```
```ruby
# BECOMES
{1 => 2}
{123 => 4}
```
### unnamed 58
```ruby
# GIVEN
{
 1 => 2,
 345 => {
  4 => 5
 }
 }
```
```ruby
# BECOMES
{
  1 => 2,
  345 => {
    4 => 5,
  },
}
```
```ruby
# with setting `trailing_commas false`
{
  1 => 2,
  345 => {
    4 => 5
  }
}
```
### unnamed 59
```ruby
# GIVEN
{
 1 => 2,
 345 => { # foo
  4 => 5
 }
 }
```
```ruby
# BECOMES
{
  1 => 2,
  345 => { # foo
    4 => 5,
  },
}
```
```ruby
# with setting `trailing_commas false`
{
  1 => 2,
  345 => { # foo
    4 => 5
  }
}
```
### unnamed 60
```ruby
# GIVEN
{
 1 => 2,
 345 => [
  4
 ]
 }
```
```ruby
# BECOMES
{
  1 => 2,
  345 => [
    4,
  ],
}
```
```ruby
# with setting `trailing_commas false`
{
  1 => 2,
  345 => [
    4
  ]
}
```
### unnamed 61
```ruby
# GIVEN
{
 1 => 2,
 foo: [
  4
 ]
 }
```
```ruby
# BECOMES
{
  1 => 2,
  foo: [
    4,
  ],
}
```
```ruby
# with setting `trailing_commas false`
{
  1 => 2,
  foo: [
    4
  ]
}
```
### unnamed 62
```ruby
# GIVEN
foo 1, bar: [
         2,
       ],
       baz: 3
```
```ruby
# BECOMES
foo 1, bar: [
         2,
       ],
       baz: 3
```
```ruby
# with setting `trailing_commas false`
foo 1, bar: [
         2
       ],
       baz: 3
```
### unnamed 63
```ruby
# GIVEN
a   = b :foo => x,
  :baar => x
```
```ruby
# BECOMES
a = b :foo => x,
      :baar => x
```
### unnamed 64
```ruby
# GIVEN
{:foo   =>   1 }
```
```ruby
# BECOMES
{:foo => 1}
```
### unnamed 65
```ruby
# GIVEN
{:foo   =>   1}
```
```ruby
# BECOMES
{:foo => 1}
```
### unnamed 66
```ruby
# GIVEN
{ :foo   =>   1 }
```
```ruby
# BECOMES
{:foo => 1}
```
### unnamed 67
```ruby
# GIVEN
{ :foo   =>   1 , 2  =>  3  }
```
```ruby
# BECOMES
{:foo => 1, 2 => 3}
```
### unnamed 68
```ruby
# GIVEN
{
 :foo   =>   1 ,
 2  =>  3  }
```
```ruby
# BECOMES
{
  :foo => 1,
  2 => 3,
}
```
```ruby
# with setting `trailing_commas false`
{
  :foo => 1,
  2 => 3
}
```
### unnamed 69
```ruby
# GIVEN
{ foo:  1,
 bar: 2 }
```
```ruby
# BECOMES
{foo: 1,
 bar: 2}
```
### unnamed 70
```ruby
# GIVEN
=begin
=end
{
  :a  => 1,
  :bc => 2
}
```
```ruby
# BECOMES
=begin
=end
{
  :a => 1,
  :bc => 2,
}
```
```ruby
# with setting `trailing_commas false`
=begin
=end
{
  :a => 1,
  :bc => 2
}
```
### unnamed 71
```ruby
# GIVEN
foo 1,  :bar  =>  2 , :baz  =>  3
```
```ruby
# BECOMES
foo 1, :bar => 2, :baz => 3
```
### unnamed 72
```ruby
# GIVEN
{
 foo: 1,
 barbaz: 2 }
```
```ruby
# BECOMES
{
  foo: 1,
  barbaz: 2,
}
```
```ruby
# with setting `trailing_commas false`
{
  foo: 1,
  barbaz: 2
}
```
