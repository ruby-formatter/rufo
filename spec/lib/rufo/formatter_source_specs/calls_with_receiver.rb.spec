#~# ORIGINAL

foo . bar . baz

#~# EXPECTED

foo.bar.baz

#~# ORIGINAL

foo . bar( 1 , 2 )

#~# EXPECTED

foo.bar(1, 2)

#~# ORIGINAL

foo .
 bar

#~# EXPECTED

foo.
  bar

#~# ORIGINAL

foo .
 bar .
 baz

#~# EXPECTED

foo.
  bar.
  baz

#~# ORIGINAL

foo
 . bar

#~# EXPECTED

foo
  .bar

#~# ORIGINAL

foo
 . bar
 . baz

#~# EXPECTED

foo
  .bar
  .baz

#~# ORIGINAL

foo.bar
.baz

#~# EXPECTED

foo.bar
  .baz

#~# ORIGINAL

foo.bar(1)
.baz(2)
.qux(3)

#~# EXPECTED

foo.bar(1)
  .baz(2)
  .qux(3)

#~# ORIGINAL

foobar.baz
.with(
1
)

#~# EXPECTED

foobar.baz
  .with(
    1
  )

#~# ORIGINAL

foo.bar 1,
 x: 1,
 y: 2

#~# EXPECTED

foo.bar 1,
        x: 1,
        y: 2

#~# ORIGINAL

foo
  .bar # x
  .baz

#~# EXPECTED

foo
  .bar # x
  .baz

#~# ORIGINAL

c.x w 1

#~# EXPECTED

c.x w 1

#~# ORIGINAL

foo.bar
  .baz
  .baz

#~# EXPECTED

foo.bar
  .baz
  .baz

#~# ORIGINAL

foo.bar
  .baz
   .baz

#~# EXPECTED

foo.bar
  .baz
  .baz

#~# ORIGINAL

foo.bar(1)
   .baz([
  2,
])

#~# EXPECTED

foo.bar(1)
   .baz([2])

#~# ORIGINAL

foo.bar(1)
   .baz(
  2,
)

#~# EXPECTED

foo.bar(1)
   .baz(
     2,
   )

#~# ORIGINAL

foo.bar(1)
   .baz(
  qux(
2
)
)

#~# EXPECTED

foo.bar(1)
   .baz(
     qux(
       2
     )
   )

#~# ORIGINAL

foo.bar(1)
   .baz(
  qux.last(
2
)
)

#~# EXPECTED

foo.bar(1)
   .baz(
     qux.last(
       2
     )
   )

#~# ORIGINAL

foo.bar(
1
)

#~# EXPECTED

foo.bar(
  1
)

#~# ORIGINAL
#~# print_width: 5

foo 1, [
  2,

  3,
]

#~# EXPECTED

foo 1, [
      2,
      3,
    ]

#~# ORIGINAL

foo :x, {
  :foo1 => :bar,

  :foo2 => bar,
}

multiline :call,
          :foo => :bar,
          :foo => bar

#~# EXPECTED

foo :x, {
  :foo1 => :bar,

  :foo2 => bar,
}

multiline :call,
          :foo => :bar,
          :foo => bar

#~# ORIGINAL

x
  .foo.bar
  .baz

#~# EXPECTED

x
  .foo.bar
  .baz

#~# ORIGINAL

x
  .foo.bar.baz
  .qux

#~# EXPECTED

x
  .foo.bar.baz
  .qux

#~# ORIGINAL

x
  .foo(a.b).bar(c.d).baz(e.f)
  .qux.z(a.b)
  .final

#~# EXPECTED

x
  .foo(a.b).bar(c.d).baz(e.f)
  .qux.z(a.b)
  .final

#~# ORIGINAL

x.y  1,  2

#~# EXPECTED

x.y 1, 2

#~# ORIGINAL

x.y \
  1,  2

#~# EXPECTED

x.y \
  1, 2
