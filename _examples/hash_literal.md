---
title: "hash\\_literal"
permalink: "/examples/hash_literal/"
toc: true
sidebar:
  nav: "examples"
---

### hash\_literal 1
```ruby
# GIVEN
{ }
```
```ruby
# BECOMES
{}
```
### hash\_literal 2
```ruby
# GIVEN
{:foo   =>   1 }
```
```ruby
# BECOMES
{:foo => 1}
```
### hash\_literal 3
```ruby
# GIVEN
{:foo   =>   1}
```
```ruby
# BECOMES
{:foo => 1}
```
### hash\_literal 4
```ruby
# GIVEN
{ :foo   =>   1 }
```
```ruby
# BECOMES
{:foo => 1}
```
### hash\_literal 5
```ruby
# GIVEN
{ :foo   =>   1 , 2  =>  3  }
```
```ruby
# BECOMES
{:foo => 1, 2 => 3}
```
### hash\_literal 6
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
### hash\_literal 7
```ruby
# GIVEN
{ **x }
```
```ruby
# BECOMES
{**x}
```
### hash\_literal 8
```ruby
# GIVEN
{foo:  1}
```
```ruby
# BECOMES
{foo: 1}
```
### hash\_literal 9
```ruby
# GIVEN
{ foo:  1 }
```
```ruby
# BECOMES
{foo: 1}
```
### hash\_literal 10
```ruby
# GIVEN
{ :foo   =>
  1 }
```
```ruby
# BECOMES
{:foo => 1}
```
### hash\_literal 11
```ruby
# GIVEN
{ "foo": 1 }
```
```ruby
# BECOMES
{"foo": 1}
```
### hash\_literal 12
```ruby
# GIVEN
{ "foo #{ 2 }": 1 }
```
```ruby
# BECOMES
{"foo #{2}": 1}
```
### hash\_literal 13
```ruby
# GIVEN
{ :"one two"  => 3 }
```
```ruby
# BECOMES
{:"one two" => 3}
```
### hash\_literal 14
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
### hash\_literal 15
```ruby
# GIVEN
{foo: 1,  bar: 2}
```
```ruby
# BECOMES
{foo: 1, bar: 2}
```
### hash\_literal 16
```ruby
# GIVEN
{1 =>
   2}
```
```ruby
# BECOMES
{1 => 2}
```
