---
title: "align\\_hash\\_keys"
permalink: "/examples/align_hash_keys/"
toc: true
sidebar:
  nav: "examples"
---

### align\_hash\_keys 1
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
### align\_hash\_keys 2
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
### align\_hash\_keys 3
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
### align\_hash\_keys 4
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
### align\_hash\_keys 5
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
### align\_hash\_keys 6
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
### align\_hash\_keys 7
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
### align\_hash\_keys 8
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
### align\_hash\_keys 9
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
### align\_hash\_keys 10
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
### align\_hash\_keys 11
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
### align\_hash\_keys 12
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
### align\_hash\_keys 13
```ruby
# GIVEN
{:foo   =>   1 }
```
```ruby
# BECOMES
{:foo => 1}
```
### align\_hash\_keys 14
```ruby
# GIVEN
{:foo   =>   1}
```
```ruby
# BECOMES
{:foo => 1}
```
### align\_hash\_keys 15
```ruby
# GIVEN
{ :foo   =>   1 }
```
```ruby
# BECOMES
{:foo => 1}
```
### align\_hash\_keys 16
```ruby
# GIVEN
{ :foo   =>   1 , 2  =>  3  }
```
```ruby
# BECOMES
{:foo => 1, 2 => 3}
```
### align\_hash\_keys 17
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
### align\_hash\_keys 18
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
### align\_hash\_keys 19
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
### align\_hash\_keys 20
```ruby
# GIVEN
foo 1,  :bar  =>  2 , :baz  =>  3
```
```ruby
# BECOMES
foo 1, :bar => 2, :baz => 3
```
### align\_hash\_keys 21
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
