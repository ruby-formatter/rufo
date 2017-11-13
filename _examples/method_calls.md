---
title: "method\\_calls"
permalink: "/examples/method_calls/"
toc: true
sidebar:
  nav: "examples"
---

### foo
```ruby
# GIVEN
foo
```
```ruby
# BECOMES
foo
```
### method\_calls 2
```ruby
# GIVEN
foo()
```
```ruby
# BECOMES
foo()
```
### method\_calls 3
```ruby
# GIVEN
foo ()
```
```ruby
# BECOMES
foo ()
```
### method\_calls 4
```ruby
# GIVEN
foo(  )
```
```ruby
# BECOMES
foo()
```
### method\_calls 5
```ruby
# GIVEN
foo(

 )
```
```ruby
# BECOMES
foo()
```
### method\_calls 6
```ruby
# GIVEN
foo(  1  )
```
```ruby
# BECOMES
foo(1)
```
### method\_calls 7
```ruby
# GIVEN
foo(  1 ,   2 )
```
```ruby
# BECOMES
foo(1, 2)
```
### method\_calls 8
```ruby
# GIVEN
foo  1
```
```ruby
# BECOMES
foo 1
```
### method\_calls 9
```ruby
# GIVEN
foo  1,  2
```
```ruby
# BECOMES
foo 1, 2
```
### method\_calls 10
```ruby
# GIVEN
foo  1,  *x
```
```ruby
# BECOMES
foo 1, *x
```
### method\_calls 11
```ruby
# GIVEN
foo  1,  *x , 2
```
```ruby
# BECOMES
foo 1, *x, 2
```
### method\_calls 12
```ruby
# GIVEN
foo  1,  *x , 2 , 3
```
```ruby
# BECOMES
foo 1, *x, 2, 3
```
### method\_calls 13
```ruby
# GIVEN
foo  1,  *x , 2 , 3 , *z , *w , 4
```
```ruby
# BECOMES
foo 1, *x, 2, 3, *z, *w, 4
```
### method\_calls 14
```ruby
# GIVEN
foo *x
```
```ruby
# BECOMES
foo *x
```
### method\_calls 15
```ruby
# GIVEN
foo 1,
  *x
```
```ruby
# BECOMES
foo 1,
  *x
```
### method\_calls 16
```ruby
# GIVEN
foo 1,  *x , *y
```
```ruby
# BECOMES
foo 1, *x, *y
```
### method\_calls 17
```ruby
# GIVEN
foo 1,  **x
```
```ruby
# BECOMES
foo 1, **x
```
### method\_calls 18
```ruby
# GIVEN
foo 1,
 **x
```
```ruby
# BECOMES
foo 1,
    **x
```
### method\_calls 19
```ruby
# GIVEN
foo 1,  **x , **y
```
```ruby
# BECOMES
foo 1, **x, **y
```
### method\_calls 20
```ruby
# GIVEN
foo 1,  bar:  2 , baz:  3
```
```ruby
# BECOMES
foo 1, bar: 2, baz: 3
```
### method\_calls 21
```ruby
# GIVEN
foo 1,
 bar:  2 , baz:  3
```
```ruby
# BECOMES
foo 1,
    bar: 2, baz: 3
```
### method\_calls 22
```ruby
# GIVEN
foo 1,
 2
```
```ruby
# BECOMES
foo 1,
    2
```
### method\_calls 23
```ruby
# GIVEN
foo(1,
 2)
```
```ruby
# BECOMES
foo(1,
    2)
```
### method\_calls 24
```ruby
# GIVEN
foo(
1,
 2)
```
```ruby
# BECOMES
foo(
  1,
  2
)
```
### method\_calls 25
```ruby
# GIVEN
foo(
1,
 2,)
```
```ruby
# BECOMES
foo(
  1,
  2,
)
```
```ruby
# with setting `trailing_commas false`
foo(
  1,
  2
)
```
### method\_calls 26
```ruby
# GIVEN
foo(
1,
 2
)
```
```ruby
# BECOMES
foo(
  1,
  2
)
```
### method\_calls 27
```ruby
# GIVEN
begin
 foo(
1,
 2
)
 end
```
```ruby
# BECOMES
begin
  foo(
    1,
    2
  )
end
```
### method\_calls 28
```ruby
# GIVEN
begin
 foo(1,
 2
 )
 end
```
```ruby
# BECOMES
begin
  foo(1,
      2)
end
```
### method\_calls 29
```ruby
# GIVEN
begin
 foo(1,
 2,
 )
 end
```
```ruby
# BECOMES
begin
  foo(1,
      2)
end
```
### method\_calls 30
```ruby
# GIVEN
begin
 foo(
 1,
 2,
 )
 end
```
```ruby
# BECOMES
begin
  foo(
    1,
    2,
  )
end
```
```ruby
# with setting `trailing_commas false`
begin
  foo(
    1,
    2
  )
end
```
### method\_calls 31
```ruby
# GIVEN
begin
 foo(
 1,
 2, )
 end
```
```ruby
# BECOMES
begin
  foo(
    1,
    2,
  )
end
```
```ruby
# with setting `trailing_commas false`
begin
  foo(
    1,
    2
  )
end
```
### method\_calls 32
```ruby
# GIVEN
begin
 foo(
1,
 2)
 end
```
```ruby
# BECOMES
begin
  foo(
    1,
    2
  )
end
```
### method\_calls 33
```ruby
# GIVEN
begin
 foo(
1,
 2 # comment
)
 end
```
```ruby
# BECOMES
begin
  foo(
    1,
    2 # comment
  )
end
```
### method\_calls 34
```ruby
# GIVEN
foo(bar(
1,
))
```
```ruby
# BECOMES
foo(bar(
  1,
))
```
```ruby
# with setting `trailing_commas false`
foo(bar(
  1
))
```
### method\_calls 35
```ruby
# GIVEN
foo(bar(
  1,
  baz(
    2
  )
))
```
```ruby
# BECOMES
foo(bar(
  1,
  baz(
    2
  )
))
```
### method\_calls 36
```ruby
# GIVEN
foo &block
```
```ruby
# BECOMES
foo &block
```
### method\_calls 37
```ruby
# GIVEN
foo 1 ,  &block
```
```ruby
# BECOMES
foo 1, &block
```
### method\_calls 38
```ruby
# GIVEN
foo(1 ,  &block)
```
```ruby
# BECOMES
foo(1, &block)
```
### method\_calls 39
```ruby
# GIVEN
x y z
```
```ruby
# BECOMES
x y z
```
### method\_calls 40
```ruby
# GIVEN
x y z w, q
```
```ruby
# BECOMES
x y z w, q
```
### method\_calls 41
```ruby
# GIVEN
x(*y, &z)
```
```ruby
# BECOMES
x(*y, &z)
```
### method\_calls 42
```ruby
# GIVEN
foo \
 1, 2
```
```ruby
# BECOMES
foo \
  1, 2
```
### method\_calls 43
```ruby
# GIVEN
a(
*b)
```
```ruby
# BECOMES
a(
  *b
)
```
### method\_calls 44
```ruby
# GIVEN
foo(
x: 1,
 y: 2
)
```
```ruby
# BECOMES
foo(
  x: 1,
  y: 2,
)
```
```ruby
# with setting `trailing_commas false`
foo(
  x: 1,
  y: 2
)
```
### method\_calls 45
```ruby
# GIVEN
foo bar(
  1,
)
```
```ruby
# BECOMES
foo bar(
  1,
)
```
```ruby
# with setting `trailing_commas false`
foo bar(
  1
)
```
### method\_calls 46
```ruby
# GIVEN
foo 1, {
  x: y,
}
```
```ruby
# BECOMES
foo 1, {
  x: y,
}
```
```ruby
# with setting `trailing_commas false`
foo 1, {
  x: y
}
```
### method\_calls 47
```ruby
# GIVEN
foo 1, [
  1,
]
```
```ruby
# BECOMES
foo 1, [
  1,
]
```
```ruby
# with setting `trailing_commas false`
foo 1, [
  1
]
```
### method\_calls 48
```ruby
# GIVEN
foo 1, [
  <<-EOF,
  bar
EOF
]
```
```ruby
# BECOMES
foo 1, [
  <<-EOF,
  bar
EOF
]
```
### method\_calls 49
```ruby
# GIVEN
foo bar( # foo
  1, # bar
)
```
```ruby
# BECOMES
foo bar( # foo
  1, # bar
)
```
```ruby
# with setting `trailing_commas false`
foo bar( # foo
  1 # bar
)
```
### method\_calls 50
```ruby
# GIVEN
foo bar {
  1
}
```
```ruby
# BECOMES
foo bar {
  1
}
```
### method\_calls 51
```ruby
# GIVEN
foo x:  1
```
```ruby
# BECOMES
foo x: 1
```
### method\_calls 52
```ruby
# GIVEN
foo(
  &block
)
```
```ruby
# BECOMES
foo(
  &block
)
```
### method\_calls 53
```ruby
# GIVEN
foo(
  1,
  &block
)
```
```ruby
# BECOMES
foo(
  1,
  &block
)
```
### method\_calls 54
```ruby
# GIVEN
foo(& block)
```
```ruby
# BECOMES
foo(&block)
```
### method\_calls 55
```ruby
# GIVEN
foo 1, [
      2,
    ]
```
```ruby
# BECOMES
foo 1, [
      2,
    ]
```
```ruby
# with setting `trailing_commas false`
foo 1, [
      2
    ]
```
### method\_calls 56
```ruby
# GIVEN
foo 1, [
  2,
]
```
```ruby
# BECOMES
foo 1, [
  2,
]
```
```ruby
# with setting `trailing_commas false`
foo 1, [
  2
]
```
### method\_calls 57
```ruby
# GIVEN
foo bar(
  2
)
```
```ruby
# BECOMES
foo bar(
  2
)
```
### method\_calls 58
```ruby
# GIVEN
foo bar(
      2
    )
```
```ruby
# BECOMES
foo bar(
      2
    )
```
### method\_calls 59
```ruby
# GIVEN
foo bar {
  2
}
```
```ruby
# BECOMES
foo bar {
  2
}
```
### method\_calls 60
```ruby
# GIVEN
foo bar {
      2
    }
```
```ruby
# BECOMES
foo bar {
      2
    }
```
### method\_calls 61
```ruby
# GIVEN
foobar 1,
  2
```
```ruby
# BECOMES
foobar 1,
  2
```
### method\_calls 62
```ruby
# GIVEN
begin
  foobar 1,
    2
end
```
```ruby
# BECOMES
begin
  foobar 1,
    2
end
```
### method\_calls 63
```ruby
# GIVEN
foo([
      1,
    ])
```
```ruby
# BECOMES
foo([
      1,
    ])
```
```ruby
# with setting `trailing_commas false`
foo([
      1
    ])
```
### method\_calls 64
```ruby
# GIVEN
begin
  foo([
        1,
      ])
end
```
```ruby
# BECOMES
begin
  foo([
        1,
      ])
end
```
```ruby
# with setting `trailing_commas false`
begin
  foo([
        1
      ])
end
```
### method\_calls 65
```ruby
# GIVEN
(a b).c([
          1,
        ])
```
```ruby
# BECOMES
(a b).c([
          1,
        ])
```
```ruby
# with setting `trailing_commas false`
(a b).c([
          1
        ])
```
### method\_calls 66
```ruby
# GIVEN
foobar 1,
  "foo
   bar"
```
```ruby
# BECOMES
foobar 1,
  "foo
   bar"
```
