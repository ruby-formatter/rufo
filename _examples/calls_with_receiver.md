---
title: "calls\\_with\\_receiver"
permalink: "/examples/calls_with_receiver/"
toc: true
sidebar:
  nav: "examples"
---

### calls\_with\_receiver 1
```ruby
# GIVEN
foo . bar . baz
```
```ruby
# BECOMES
foo.bar.baz
```
### calls\_with\_receiver 2
```ruby
# GIVEN
foo . bar( 1 , 2 )
```
```ruby
# BECOMES
foo.bar(1, 2)
```
### calls\_with\_receiver 3
```ruby
# GIVEN
foo .
 bar
```
```ruby
# BECOMES
foo.
  bar
```
### calls\_with\_receiver 4
```ruby
# GIVEN
foo .
 bar .
 baz
```
```ruby
# BECOMES
foo.
  bar.
  baz
```
### calls\_with\_receiver 5
```ruby
# GIVEN
foo
 . bar
```
```ruby
# BECOMES
foo
  .bar
```
### calls\_with\_receiver 6
```ruby
# GIVEN
foo
 . bar
 . baz
```
```ruby
# BECOMES
foo
  .bar
  .baz
```
### calls\_with\_receiver 7
```ruby
# GIVEN
foo.bar
.baz
```
```ruby
# BECOMES
foo.bar
  .baz
```
```ruby
# with setting `align_chained_calls true`
foo.bar
   .baz
```
### calls\_with\_receiver 8
```ruby
# GIVEN
foo.bar(1)
.baz(2)
.qux(3)
```
```ruby
# BECOMES
foo.bar(1)
  .baz(2)
  .qux(3)
```
```ruby
# with setting `align_chained_calls true`
foo.bar(1)
   .baz(2)
   .qux(3)
```
### calls\_with\_receiver 9
```ruby
# GIVEN
foobar.baz
.with(
1
)
```
```ruby
# BECOMES
foobar.baz
  .with(
    1
  )
```
```ruby
# with setting `align_chained_calls true`
foobar.baz
      .with(
        1
      )
```
### calls\_with\_receiver 10
```ruby
# GIVEN
foo.bar 1,
 x: 1,
 y: 2
```
```ruby
# BECOMES
foo.bar 1,
        x: 1,
        y: 2
```
### calls\_with\_receiver 11
```ruby
# GIVEN
foo
  .bar # x
  .baz
```
```ruby
# BECOMES
foo
  .bar # x
  .baz
```
### calls\_with\_receiver 12
```ruby
# GIVEN
c.x w 1
```
```ruby
# BECOMES
c.x w 1
```
### calls\_with\_receiver 13
```ruby
# GIVEN
foo.bar
  .baz
  .baz
```
```ruby
# BECOMES
foo.bar
  .baz
  .baz
```
```ruby
# with setting `align_chained_calls true`
foo.bar
   .baz
   .baz
```
### calls\_with\_receiver 14
```ruby
# GIVEN
foo.bar
  .baz
   .baz
```
```ruby
# BECOMES
foo.bar
  .baz
  .baz
```
```ruby
# with setting `align_chained_calls true`
foo.bar
   .baz
   .baz
```
### calls\_with\_receiver 15
```ruby
# GIVEN
foo.bar(1)
   .baz([
  2,
])
```
```ruby
# BECOMES
foo.bar(1)
   .baz([
     2,
   ])
```
```ruby
# with setting `trailing_commas false`
foo.bar(1)
   .baz([
     2
   ])
```
### calls\_with\_receiver 16
```ruby
# GIVEN
foo.bar(1)
   .baz(
  2,
)
```
```ruby
# BECOMES
foo.bar(1)
   .baz(
     2,
   )
```
```ruby
# with setting `trailing_commas false`
foo.bar(1)
   .baz(
     2
   )
```
### calls\_with\_receiver 17
```ruby
# GIVEN
foo.bar(1)
   .baz(
  qux(
2
)
)
```
```ruby
# BECOMES
foo.bar(1)
   .baz(
     qux(
       2
     )
   )
```
### calls\_with\_receiver 18
```ruby
# GIVEN
foo.bar(1)
   .baz(
  qux.last(
2
)
)
```
```ruby
# BECOMES
foo.bar(1)
   .baz(
     qux.last(
       2
     )
   )
```
### calls\_with\_receiver 19
```ruby
# GIVEN
foo.bar(
1
)
```
```ruby
# BECOMES
foo.bar(
  1
)
```
### calls\_with\_receiver 20
```ruby
# GIVEN
foo 1, [
  2,

  3,
]
```
```ruby
# BECOMES
foo 1, [
  2,

  3,
]
```
```ruby
# with setting `trailing_commas false`
foo 1, [
  2,

  3
]
```
### calls\_with\_receiver 21
```ruby
# GIVEN
foo :x, {
  :foo1 => :bar,

  :foo2 => bar,
}

multiline :call,
          :foo => :bar,
          :foo => bar
```
```ruby
# BECOMES
foo :x, {
  :foo1 => :bar,

  :foo2 => bar,
}

multiline :call,
          :foo => :bar,
          :foo => bar
```
```ruby
# with setting `trailing_commas false`
foo :x, {
  :foo1 => :bar,

  :foo2 => bar
}

multiline :call,
          :foo => :bar,
          :foo => bar
```
### calls\_with\_receiver 22
```ruby
# GIVEN
x
  .foo.bar
  .baz
```
```ruby
# BECOMES
x
  .foo.bar
  .baz
```
### calls\_with\_receiver 23
```ruby
# GIVEN
x
  .foo.bar.baz
  .qux
```
```ruby
# BECOMES
x
  .foo.bar.baz
  .qux
```
### calls\_with\_receiver 24
```ruby
# GIVEN
x
  .foo(a.b).bar(c.d).baz(e.f)
  .qux.z(a.b)
  .final
```
```ruby
# BECOMES
x
  .foo(a.b).bar(c.d).baz(e.f)
  .qux.z(a.b)
  .final
```
### calls\_with\_receiver 25
```ruby
# GIVEN
x.y  1,  2
```
```ruby
# BECOMES
x.y 1, 2
```
### calls\_with\_receiver 26
```ruby
# GIVEN
x.y \
  1,  2
```
```ruby
# BECOMES
x.y \
  1, 2
```
