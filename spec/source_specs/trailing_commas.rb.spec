#~# ORIGINAL
#~# trailing_commas: :dynamic

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
#~# trailing_commas: :always

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
#~# trailing_commas: :never

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
#~# trailing_commas: :dynamic

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
#~# trailing_commas: :always

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
#~# trailing_commas: :never

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
#~# trailing_commas: :dynamic

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
#~# trailing_commas: :always

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
#~# trailing_commas: :never

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
#~# trailing_commas: :dynamic

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
#~# trailing_commas: :always

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
#~# trailing_commas: :never

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
#~# trailing_commas: :dynamic

foo(
  one:   1,
  two:   2,
  three: 3,
)

#~# EXPECTED

foo(
  one:   1,
  two:   2,
  three: 3,
)

#~# ORIGINAL
#~# trailing_commas: :always

foo(
  one:   1,
  two:   2,
  three: 3,
)

#~# EXPECTED

foo(
  one:   1,
  two:   2,
  three: 3,
)

#~# ORIGINAL
#~# trailing_commas: :never

foo(
  one:   1,
  two:   2,
  three: 3,
)

#~# EXPECTED

foo(
  one:   1,
  two:   2,
  three: 3
)

#~# ORIGINAL
#~# trailing_commas: :dynamic

foo(
  one:   1,
  two:   2,
  three: 3
)

#~# EXPECTED

foo(
  one:   1,
  two:   2,
  three: 3
)

#~# ORIGINAL
#~# trailing_commas: :always

foo(
  one:   1,
  two:   2,
  three: 3
)

#~# EXPECTED

foo(
  one:   1,
  two:   2,
  three: 3,
)

#~# ORIGINAL
#~# trailing_commas: :never

foo(
  one:   1,
  two:   2,
  three: 3
)

#~# EXPECTED

foo(
  one:   1,
  two:   2,
  three: 3
)

#~# ORIGINAL
#~# trailing_commas: :dynamic

foo(
  one: 1)

#~# EXPECTED

foo(
  one: 1
)

#~# ORIGINAL
#~# trailing_commas: :always

foo(
  one: 1)

#~# EXPECTED

foo(
  one: 1,
)

#~# ORIGINAL
#~# trailing_commas: :never

foo(
  one: 1)

#~# EXPECTED

foo(
  one: 1
)

#~# ORIGINAL
#~# trailing_commas: :dynamic

foo(
  one: 1,)

#~# EXPECTED

foo(
  one: 1,
)

#~# ORIGINAL
#~# trailing_commas: :always

foo(
  one: 1,)

#~# EXPECTED

foo(
  one: 1,
)

#~# ORIGINAL
#~# trailing_commas: :never

foo(
  one: 1,)

#~# EXPECTED

foo(
  one: 1
)

#~# ORIGINAL
#~# trailing_commas: :always

 [ 
 1 , 2 ] 

#~# EXPECTED

[
  1, 2,
]

#~# ORIGINAL
#~# trailing_commas: :always

 [ 
 1 , 2, ] 

#~# EXPECTED

[
  1, 2,
]

#~# ORIGINAL
#~# trailing_commas: :always

 [ 
 1 , 2 , 
 3 , 4 ] 

#~# EXPECTED

[
  1, 2,
  3, 4,
]

#~# ORIGINAL
#~# trailing_commas: :always

 [ 
 1 , 
 2] 

#~# EXPECTED

[
  1,
  2,
]

#~# ORIGINAL
#~# trailing_commas: :always

 [  # comment 
 1 , 
 2] 

#~# EXPECTED

[ # comment
  1,
  2,
]

#~# ORIGINAL
#~# trailing_commas: :always

 [ 
 1 ,  # comment  
 2] 

#~# EXPECTED

[
  1,  # comment
  2,
]

#~# ORIGINAL
#~# trailing_commas: :always

 [ 1 , 
 2, 3, 
 4 ] 

#~# EXPECTED

[ 1,
  2, 3,
  4 ]

#~# ORIGINAL
#~# trailing_commas: :always

 [ 1 , 
 2, 3, 
 4, ] 

#~# EXPECTED

[ 1,
  2, 3,
  4 ]

#~# ORIGINAL
#~# trailing_commas: :always

 [ 1 , 
 2, 3, 
 4,
 ] 

#~# EXPECTED

[ 1,
  2, 3,
  4 ]

#~# ORIGINAL
#~# trailing_commas: :always

 [ 1 , 
 2, 3, 
 4, # foo 
 ] 

#~# EXPECTED

[ 1,
  2, 3,
  4 # foo
]

#~# ORIGINAL
#~# trailing_commas: :always

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
#~# trailing_commas: :always

 [ 
 1 # foo
 ]

#~# EXPECTED

[
  1, # foo
]

