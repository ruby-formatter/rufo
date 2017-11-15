#~# ORIGINAL

 [  ]

#~# EXPECTED

[]

#~# ORIGINAL

 [  1 ]

#~# EXPECTED

[1]

#~# ORIGINAL

 [  1 , 2 ]

#~# EXPECTED

[1, 2]

#~# ORIGINAL

 [  1 , 2 , ]

#~# EXPECTED

[1, 2]

#~# ORIGINAL
#~# print_width: 4

 [
 1 , 2 ]

#~# EXPECTED

[
  1,
  2,
]

#~# ORIGINAL
#~# print_width: 4

 [
 1 , 2, ]

#~# EXPECTED

[
  1,
  2,
]

#~# ORIGINAL
#~# print_width: 4

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
#~# print_width: 4

 [
 1 ,
 2]

#~# EXPECTED

[
  1,
  2,
]

#~# ORIGINAL

 [  # comment
 1 ,
 2]

#~# EXPECTED

[ # comment
  1,
  2,
]

#~# ORIGINAL

 [
 1 ,  # comment
 2]

#~# EXPECTED

[
  1, # comment
  2,
]

#~# ORIGINAL
#~# print_width: 4

 [  1 ,
 2, 3,
 4 ]

#~# EXPECTED

[
  1,
  2,
  3,
  4,
]

#~# ORIGINAL

 [  1 ,
 2, 3,
 4, ]

#~# EXPECTED

[1, 2, 3, 4]

#~# ORIGINAL

 [  1 ,
 2, 3,
 4,
 ]

#~# EXPECTED

[1, 2, 3, 4]

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
  4, # foo
]

#~# ORIGINAL

 begin
 [
 1 , 2 ]
 end

#~# EXPECTED

begin
  [1, 2]
end

#~# ORIGINAL

 [
 1 # foo
 ]

#~# EXPECTED

[
  1, # foo
]

#~# ORIGINAL

 [ *x ]

#~# EXPECTED

[*x]

#~# ORIGINAL

 [ *x , 1 ]

#~# EXPECTED

[*x, 1]

#~# ORIGINAL

 [ 1, *x ]

#~# EXPECTED

[1, *x]

#~# ORIGINAL

 x = [{
 foo: 1
}]

#~# EXPECTED

x = [{
  foo: 1,
}]

#~# ORIGINAL

[1,   2]

#~# EXPECTED

[1, 2]

#~# ORIGINAL

[
  1,
  # comment
  2,
]

#~# EXPECTED

[
  1,
  # comment
  2,
]

#~# ORIGINAL

[
  *a,
  b,
]

#~# EXPECTED

[
  *a,
  b,
]

#~# ORIGINAL

[
  1, *a,
  b,
]

#~# EXPECTED

[
  1, *a,
  b,
]
