#~# ORIGINAL
#~# trailing_commas: true
#~# print_width: 5

[
  1,
  2,
]

#~# EXPECTED

[
  1,
  2,
]

#~# ORIGINAL
#~# trailing_commas: false
#~# print_width: 5

[
  1,
  2,
]

#~# EXPECTED

[
  1,
  2
]

#~# ORIGINAL
#~# trailing_commas: true
#~# print_width: 5

[
  1,
  2
]

#~# EXPECTED

[
  1,
  2,
]

#~# ORIGINAL
#~# trailing_commas: false
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
#~# trailing_commas: true

{
  foo: 1,
  bar: 2,
}

#~# EXPECTED

{
  foo: 1,
  bar: 2,
}

#~# ORIGINAL
#~# trailing_commas: false

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
#~# trailing_commas: true

{
  foo: 1,
  bar: 2
}

#~# EXPECTED

{
  foo: 1,
  bar: 2,
}

#~# ORIGINAL
#~# trailing_commas: false

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
#~# trailing_commas: true

foo(
  one:   1,
  two:   2,
  three: 3,
)

#~# EXPECTED

foo(
  one: 1,
  two: 2,
  three: 3,
)

#~# ORIGINAL
#~# trailing_commas: false

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
#~# trailing_commas: true

foo(
  one:   1,
  two:   2,
  three: 3
)

#~# EXPECTED

foo(
  one: 1,
  two: 2,
  three: 3,
)

#~# ORIGINAL
#~# trailing_commas: false

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
#~# trailing_commas: true

foo(
  one: 1)

#~# EXPECTED

foo(
  one: 1,
)

#~# ORIGINAL
#~# trailing_commas: false

foo(
  one: 1)

#~# EXPECTED

foo(
  one: 1
)

#~# ORIGINAL
#~# trailing_commas: true

foo(
  one: 1,)

#~# EXPECTED

foo(
  one: 1,
)

#~# ORIGINAL
#~# trailing_commas: false

foo(
  one: 1,)

#~# EXPECTED

foo(
  one: 1
)

#~# ORIGINAL
#~# trailing_commas: true
#~# print_width: 5

 [
 1 , 2 ]

#~# EXPECTED

[
  1,
  2,
]

#~# ORIGINAL
#~# trailing_commas: true
#~# print_width: 5

 [
 1 , 2, ]

#~# EXPECTED

[
  1,
  2,
]

#~# ORIGINAL
#~# trailing_commas: true
#~# print_width: 5

 [
 1 , 2 ,
 3 , 4 ]

#~# EXPECTED

[
  1,
  2,
  3,
  4,
]

#~# ORIGINAL
#~# trailing_commas: true
#~# print_width: 5

 [
 1 ,
 2]

#~# EXPECTED

[
  1,
  2,
]

#~# ORIGINAL
#~# trailing_commas: true

 [  # comment
 1 ,
 2]

#~# EXPECTED

[ # comment
  1,
  2,
]

#~# ORIGINAL
#~# trailing_commas: true

 [
 1 ,  # comment
 2]

#~# EXPECTED

[
  1,  # comment
  2,
]

#~# ORIGINAL
#~# trailing_commas: true
#~# print_width: 6

 [ 1 ,
 2, 3,
 4 ]

#~# EXPECTED

[1,
 2, 3,
 4]

#~# ORIGINAL
#~# trailing_commas: true

 [ 1 ,
 2, 3,
 4, ]

#~# EXPECTED

[1,
 2, 3,
 4]

#~# ORIGINAL
#~# trailing_commas: true

 [ 1 ,
 2, 3,
 4,
 ]

#~# EXPECTED

[1,
 2, 3,
 4]

#~# ORIGINAL
#~# trailing_commas: true

 [ 1 ,
 2, 3,
 4, # foo
 ]

#~# EXPECTED

[1,
 2, 3,
 4 # foo
]

#~# ORIGINAL
#~# trailing_commas: true
#~# print_width: 5

 begin
 [
 1 , 2 ]
 end

#~# EXPECTED

begin
  [
    1, 2,
  ]
end

#~# ORIGINAL
#~# trailing_commas: true

 [
 1 # foo
 ]

#~# EXPECTED

[
  1, # foo
]

