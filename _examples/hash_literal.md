---
title: "hash\\_literal"
permalink: "/examples/hash_literal/"
toc: true
sidebar:
  nav: "examples"
---

### unnamed 334
```ruby
# GIVEN
{ }
```
```ruby
# BECOMES
{}
```
### unnamed 335
```ruby
# GIVEN
{:foo   =>   1 }
```
```ruby
# BECOMES
{:foo => 1}
```
### unnamed 336
```ruby
# GIVEN
{:foo   =>   1}
```
```ruby
# BECOMES
{:foo => 1}
```
### unnamed 337
```ruby
# GIVEN
{ :foo   =>   1 }
```
```ruby
# BECOMES
{:foo => 1}
```
### unnamed 338
```ruby
# GIVEN
{ :foo   =>   1 , 2  =>  3  }
```
```ruby
# BECOMES
{:foo => 1, 2 => 3}
```
### unnamed 339
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
### unnamed 340
```ruby
# GIVEN
{ **x }
```
```ruby
# BECOMES
{**x}
```
### unnamed 341
```ruby
# GIVEN
{foo:  1}
```
```ruby
# BECOMES
{foo: 1}
```
### unnamed 342
```ruby
# GIVEN
{ foo:  1 }
```
```ruby
# BECOMES
{foo: 1}
```
### unnamed 343
```ruby
# GIVEN
{ :foo   =>
  1 }
```
```ruby
# BECOMES
{:foo => 1}
```
### unnamed 344
```ruby
# GIVEN
{ "foo": 1 }
```
```ruby
# BECOMES
{"foo": 1}
```
### unnamed 345
```ruby
# GIVEN
{ "foo #{ 2 }": 1 }
```
```ruby
# BECOMES
{"foo #{2}": 1}
```
### unnamed 346
```ruby
# GIVEN
{ :"one two"  => 3 }
```
```ruby
# BECOMES
{:"one two" => 3}
```
### unnamed 347
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
### unnamed 348
```ruby
# GIVEN
{foo: 1,  bar: 2}
```
```ruby
# BECOMES
{foo: 1, bar: 2}
```
### unnamed 349
```ruby
# GIVEN
{1 =>
   2}
```
```ruby
# BECOMES
{1 => 2}
```
