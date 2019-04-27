#~# ORIGINAL foo

foo

#~# EXPECTED

foo

#~# ORIGINAL

foo()

#~# EXPECTED

foo()

#~# ORIGINAL

foo ()

#~# EXPECTED

foo ()

#~# ORIGINAL

foo(  )

#~# EXPECTED

foo()

#~# ORIGINAL

foo(

 )

#~# EXPECTED

foo()

#~# ORIGINAL

foo(  1  )

#~# EXPECTED

foo(1)

#~# ORIGINAL

foo(  1 ,   2 )

#~# EXPECTED

foo(1, 2)

#~# ORIGINAL

foo  1

#~# EXPECTED

foo 1

#~# ORIGINAL

foo  1,  2

#~# EXPECTED

foo 1, 2

#~# ORIGINAL

foo  1,  *x

#~# EXPECTED

foo 1, *x

#~# ORIGINAL

foo  1,  *x , 2

#~# EXPECTED

foo 1, *x, 2

#~# ORIGINAL

foo  1,  *x , 2 , 3

#~# EXPECTED

foo 1, *x, 2, 3

#~# ORIGINAL

foo  1,  *x , 2 , 3 , *z , *w , 4

#~# EXPECTED

foo 1, *x, 2, 3, *z, *w, 4

#~# ORIGINAL

foo *x

#~# EXPECTED

foo *x

#~# ORIGINAL

foo 1,
  *x

#~# EXPECTED

foo 1,
  *x

#~# ORIGINAL

foo 1,  *x , *y

#~# EXPECTED

foo 1, *x, *y

#~# ORIGINAL

foo 1,  **x

#~# EXPECTED

foo 1, **x

#~# ORIGINAL

foo 1,
 **x

#~# EXPECTED

foo 1,
    **x

#~# ORIGINAL

foo 1,  **x , **y

#~# EXPECTED

foo 1, **x, **y

#~# ORIGINAL

foo 1,  bar:  2 , baz:  3

#~# EXPECTED

foo 1, bar: 2, baz: 3

#~# ORIGINAL

foo 1,
 bar:  2 , baz:  3

#~# EXPECTED

foo 1,
    bar: 2, baz: 3

#~# ORIGINAL

foo 1,
 2

#~# EXPECTED

foo 1,
    2

#~# ORIGINAL

foo(1,
 2)

#~# EXPECTED

foo(1,
    2)

#~# ORIGINAL

foo(
1,
 2)

#~# EXPECTED

foo(
  1,
  2
)

#~# ORIGINAL

foo(
1,
 2,)

#~# EXPECTED

foo(
  1,
  2,
)

#~# ORIGINAL

foo(
1,
 2
)

#~# EXPECTED

foo(
  1,
  2
)

#~# ORIGINAL

begin
 foo(
1,
 2
)
 end

#~# EXPECTED

begin
  foo(
    1,
    2
  )
end

#~# ORIGINAL

begin
 foo(1,
 2
 )
 end

#~# EXPECTED

begin
  foo(1,
      2)
end

#~# ORIGINAL

begin
 foo(1,
 2,
 )
 end

#~# EXPECTED

begin
  foo(1,
      2)
end

#~# ORIGINAL

begin
 foo(
 1,
 2,
 )
 end

#~# EXPECTED

begin
  foo(
    1,
    2,
  )
end

#~# ORIGINAL

begin
 foo(
 1,
 2, )
 end

#~# EXPECTED

begin
  foo(
    1,
    2,
  )
end

#~# ORIGINAL

begin
 foo(
1,
 2)
 end

#~# EXPECTED

begin
  foo(
    1,
    2
  )
end

#~# ORIGINAL

begin
 foo(
1,
 2 # comment
)
 end

#~# EXPECTED

begin
  foo(
    1,
    2 # comment
  )
end

#~# ORIGINAL

foo(bar(
1,
))

#~# EXPECTED

foo(bar(
  1,
))

#~# ORIGINAL

foo(bar(
  1,
  baz(
    2
  )
))

#~# EXPECTED

foo(bar(
  1,
  baz(
    2
  )
))

#~# ORIGINAL

foo &block

#~# EXPECTED

foo &block

#~# ORIGINAL

foo 1 ,  &block

#~# EXPECTED

foo 1, &block

#~# ORIGINAL

foo(1 ,  &block)

#~# EXPECTED

foo(1, &block)

#~# ORIGINAL

x y z

#~# EXPECTED

x y z

#~# ORIGINAL

x y z w, q

#~# EXPECTED

x y z w, q

#~# ORIGINAL

x(*y, &z)

#~# EXPECTED

x(*y, &z)

#~# ORIGINAL

foo \
 1, 2

#~# EXPECTED

foo \
  1, 2

#~# ORIGINAL

a(
*b)

#~# EXPECTED

a(
  *b
)

#~# ORIGINAL

foo(
x: 1,
 y: 2
)

#~# EXPECTED

foo(
  x: 1,
  y: 2,
)

#~# ORIGINAL

foo bar(
  1,
)

#~# EXPECTED

foo bar(
  1,
)

#~# ORIGINAL

foo 1, {
  x: y,
}

#~# EXPECTED

foo 1, {
  x: y,
}

#~# ORIGINAL

foo 1, [
  1,
]

#~# EXPECTED

foo 1, [
  1,
]

#~# ORIGINAL

foo 1, [
  <<-EOF,
  bar
EOF
]

#~# EXPECTED

foo 1, [
  <<-EOF,
  bar
EOF
]

#~# ORIGINAL

foo bar( # foo
  1, # bar
)

#~# EXPECTED

foo bar( # foo
  1, # bar
)

#~# ORIGINAL

foo bar {
  1
}

#~# EXPECTED

foo bar {
  1
}

#~# ORIGINAL

foo x:  1

#~# EXPECTED

foo x: 1

#~# ORIGINAL

foo(
  &block
)

#~# EXPECTED

foo(
  &block
)

#~# ORIGINAL

foo(
  1,
  &block
)

#~# EXPECTED

foo(
  1,
  &block
)

#~# ORIGINAL

foo(& block)

#~# EXPECTED

foo(&block)

#~# ORIGINAL

foo 1, [
      2,
    ]

#~# EXPECTED

foo 1, [
      2,
    ]

#~# ORIGINAL

foo 1, [
  2,
]

#~# EXPECTED

foo 1, [
  2,
]

#~# ORIGINAL

foo bar(
  2
)

#~# EXPECTED

foo bar(
  2
)

#~# ORIGINAL

foo bar(
      2
    )

#~# EXPECTED

foo bar(
      2
    )

#~# ORIGINAL

foo bar {
  2
}

#~# EXPECTED

foo bar {
  2
}

#~# ORIGINAL

foo bar {
      2
    }

#~# EXPECTED

foo bar {
      2
    }

#~# ORIGINAL

foobar 1,
  2

#~# EXPECTED

foobar 1,
  2

#~# ORIGINAL

begin
  foobar 1,
    2
end

#~# EXPECTED

begin
  foobar 1,
    2
end

#~# ORIGINAL

foo([
      1,
    ])

#~# EXPECTED

foo([
      1,
    ])

#~# ORIGINAL

begin
  foo([
        1,
      ])
end

#~# EXPECTED

begin
  foo([
        1,
      ])
end

#~# ORIGINAL

(a b).c([
          1,
        ])

#~# EXPECTED

(a b).c([
          1,
        ])

#~# ORIGINAL

foobar 1,
  "foo
   bar"

#~# EXPECTED

foobar 1,
  "foo
   bar"

#~# ORIGINAL issue_86_1

foo([
      [
        bar
      ]
    ])

#~# EXPECTED

foo([
      [
        bar,
      ],
    ])

#~# ORIGINAL issue_86_2

foo([
      [
        bar,
      ],
    ])

#~# EXPECTED

foo([
      [
        bar,
      ],
    ])

#~# ORIGINAL issue_86_3
#~# trailing_commas: false

foo([
      [
        bar,
      ],
    ])

#~# EXPECTED

foo([
      [
        bar
      ]
    ])

#~# ORIGINAL issue_123_1

foo(
  bar,
*baz,
qux,
raz
)

#~# EXPECTED

foo(
  bar,
  *baz,
  qux,
  raz
)

#~# ORIGINAL issue_123_2

foo(*bar, baz,
  qux)

#~# EXPECTED

foo(*bar, baz,
    qux)
