#~# ORIGINAL
#~# print_width: 5

[
  1,
  2
]

#~# EXPECTED

[
  1,
  2
]

#~# ORIGINAL
#~# print_width: 5

[
  1,
  2
]

#~# EXPECTED

[
  1,
  2
]

#~# ORIGINAL
#~# print_width: 5

[
  1,
  2
]

#~# EXPECTED

[
  1,
  2
]

#~# ORIGINAL
#~# print_width: 5

[
  1,
  2
]

#~# EXPECTED

[
  1,
  2
]

#~# ORIGINAL
#~# print_width: 12

{
  foo: 1,
  bar: 2,
}

#~# EXPECTED

{
  foo: 1,
  bar: 2
}

#~# ORIGINAL
#~# print_width: 12

{
  foo: 1,
  bar: 2,
}

#~# EXPECTED

{
  foo: 1,
  bar: 2
}

#~# ORIGINAL
#~# print_width: 12

{
  foo: 1,
  bar: 2
}

#~# EXPECTED

{
  foo: 1,
  bar: 2
}

#~# ORIGINAL
#~# print_width: 12

{
  foo: 1,
  bar: 2
}

#~# EXPECTED

{
  foo: 1,
  bar: 2
}

#~# ORIGINAL
#~# print_width: 5

foo(
  one:   1,
  two:   2,
  three: 3,
)

#~# EXPECTED

foo(
  one: 1,
  two: 2,
  three: 3
)

#~# ORIGINAL
#~# print_width: 5

foo(
  one:   1,
  two:   2,
  three: 3
)

#~# EXPECTED

foo(
  one: 1,
  two: 2,
  three: 3
)

#~# ORIGINAL
#~# print_width: 5

foo(
  one:   1,
  two:   2,
  three: 3
)

#~# EXPECTED

foo(
  one: 1,
  two: 2,
  three: 3
)

#~# ORIGINAL
#~# print_width: 5

foo(
  one:   1,
  two:   2,
  three: 3
)

#~# EXPECTED

foo(
  one: 1,
  two: 2,
  three: 3
)

#~# ORIGINAL
#~# print_width: 5

foo(
  one: 1)

#~# EXPECTED

foo(
  one: 1
)

#~# ORIGINAL
#~# print_width: 5

foo(
  one: 1)

#~# EXPECTED

foo(
  one: 1
)

#~# ORIGINAL
#~# print_width: 5

foo(
  one: 1,)

#~# EXPECTED

foo(
  one: 1
)

#~# ORIGINAL
#~# print_width: 5

foo(
  one: 1,)

#~# EXPECTED

foo(
  one: 1
)

#~# ORIGINAL
#~# print_width: 5

 [
 1 , 2 ]

#~# EXPECTED

[
  1,
  2
]

#~# ORIGINAL
#~# print_width: 5

 [
 1 , 2, ]

#~# EXPECTED

[
  1,
  2
]

#~# ORIGINAL
#~# print_width: 5

 [
 1 , 2 ,
 3 , 4 ]

#~# EXPECTED

[
  1,
  2,
  3,
  4
]

#~# ORIGINAL
#~# print_width: 5

 [
 1 ,
 2]

#~# EXPECTED

[
  1,
  2
]

#~# ORIGINAL

 [  # comment
 1 ,
 2]

#~# EXPECTED

[
  # comment
  1,
  2
]

#~# ORIGINAL

 [
 1 ,  # comment
 2]

#~# EXPECTED

[
  1, # comment
  2
]

#~# ORIGINAL
#~# print_width: 5

 [ 1 ,
 2, 3,
 4 ]

#~# EXPECTED

[
  1,
  2,
  3,
  4
]

#~# ORIGINAL
#~# print_width: 5

 [ 1 ,
 2, 3,
 4, ]

#~# EXPECTED

[
  1,
  2,
  3,
  4
]

#~# ORIGINAL
#~# print_width: 5

 [ 1 ,
 2, 3,
 4,
 ]

#~# EXPECTED

[
  1,
  2,
  3,
  4
]

#~# ORIGINAL

 [ 1 ,
 2, 3,
 4, # foo
 ]

#~# EXPECTED

[
  1,
  2,
  3,
  4 # foo
]

#~# ORIGINAL
#~# print_width: 5

 begin
 [
 1 , 2 ]
 end

#~# EXPECTED

begin
  [
    1,
    2
  ]
end

#~# ORIGINAL

 [
 1 # foo
 ]

#~# EXPECTED

[
  1 # foo
]

