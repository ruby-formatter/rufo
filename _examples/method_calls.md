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
### unnamed 397
```ruby
# GIVEN
foo()
```
```ruby
# BECOMES
foo()
```
### unnamed 398
```ruby
# GIVEN
foo ()
```
```ruby
# BECOMES
foo ()
```
### unnamed 399
```ruby
# GIVEN
foo(  )
```
```ruby
# BECOMES
foo()
```
### unnamed 400
```ruby
# GIVEN
foo(

 )
```
```ruby
# BECOMES
foo()
```
### unnamed 401
```ruby
# GIVEN
foo(  1  )
```
```ruby
# BECOMES
foo(1)
```
### unnamed 402
```ruby
# GIVEN
foo(  1 ,   2 )
```
```ruby
# BECOMES
foo(1, 2)
```
### unnamed 403
```ruby
# GIVEN
foo  1
```
```ruby
# BECOMES
foo 1
```
### unnamed 404
```ruby
# GIVEN
foo  1,  2
```
```ruby
# BECOMES
foo 1, 2
```
### unnamed 405
```ruby
# GIVEN
foo  1,  *x
```
```ruby
# BECOMES
foo 1, *x
```
### unnamed 406
```ruby
# GIVEN
foo  1,  *x , 2
```
```ruby
# BECOMES
foo 1, *x, 2
```
### unnamed 407
```ruby
# GIVEN
foo  1,  *x , 2 , 3
```
```ruby
# BECOMES
foo 1, *x, 2, 3
```
### unnamed 408
```ruby
# GIVEN
foo  1,  *x , 2 , 3 , *z , *w , 4
```
```ruby
# BECOMES
foo 1, *x, 2, 3, *z, *w, 4
```
### unnamed 409
```ruby
# GIVEN
foo *x
```
```ruby
# BECOMES
foo *x
```
### unnamed 410
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
### unnamed 411
```ruby
# GIVEN
foo 1,  *x , *y
```
```ruby
# BECOMES
foo 1, *x, *y
```
### unnamed 412
```ruby
# GIVEN
foo 1,  **x
```
```ruby
# BECOMES
foo 1, **x
```
### unnamed 413
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
### unnamed 414
```ruby
# GIVEN
foo 1,  **x , **y
```
```ruby
# BECOMES
foo 1, **x, **y
```
### unnamed 415
```ruby
# GIVEN
foo 1,  bar:  2 , baz:  3
```
```ruby
# BECOMES
foo 1, bar: 2, baz: 3
```
### unnamed 416
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
### unnamed 417
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
### unnamed 418
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
### unnamed 419
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
### unnamed 420
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
### unnamed 421
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
### unnamed 422
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
### unnamed 423
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
### unnamed 424
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
### unnamed 425
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
### unnamed 426
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
### unnamed 427
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
### unnamed 428
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
### unnamed 429
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
### unnamed 430
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
### unnamed 431
```ruby
# GIVEN
foo &block
```
```ruby
# BECOMES
foo &block
```
### unnamed 432
```ruby
# GIVEN
foo 1 ,  &block
```
```ruby
# BECOMES
foo 1, &block
```
### unnamed 433
```ruby
# GIVEN
foo(1 ,  &block)
```
```ruby
# BECOMES
foo(1, &block)
```
### unnamed 434
```ruby
# GIVEN
x y z
```
```ruby
# BECOMES
x y z
```
### unnamed 435
```ruby
# GIVEN
x y z w, q
```
```ruby
# BECOMES
x y z w, q
```
### unnamed 436
```ruby
# GIVEN
x(*y, &z)
```
```ruby
# BECOMES
x(*y, &z)
```
### unnamed 437
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
### unnamed 438
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
### unnamed 439
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
### unnamed 440
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
### unnamed 441
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
### unnamed 442
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
### unnamed 443
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
### unnamed 444
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
### unnamed 445
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
### unnamed 446
```ruby
# GIVEN
foo x:  1
```
```ruby
# BECOMES
foo x: 1
```
### unnamed 447
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
### unnamed 448
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
### unnamed 449
```ruby
# GIVEN
foo(& block)
```
```ruby
# BECOMES
foo(&block)
```
### unnamed 450
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
### unnamed 451
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
### unnamed 452
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
### unnamed 453
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
### unnamed 454
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
### unnamed 455
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
### unnamed 456
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
### unnamed 457
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
### unnamed 458
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
### unnamed 459
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
### unnamed 460
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
### unnamed 461
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
