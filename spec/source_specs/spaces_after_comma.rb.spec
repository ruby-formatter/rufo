#~# ORIGINAL
#~# spaces_after_comma: :one

foo 1,  2,  3

#~# EXPECTED

foo 1, 2, 3

#~# ORIGINAL
#~# spaces_after_comma: :dynamic

foo 1,  2,  3

#~# EXPECTED

foo 1,  2,  3

#~# ORIGINAL
#~# spaces_after_comma: :one

foo(1,  2,  3)

#~# EXPECTED

foo(1, 2, 3)

#~# ORIGINAL
#~# spaces_after_comma: :dynamic

foo(1,  2,  3)

#~# EXPECTED

foo(1,  2,  3)

#~# ORIGINAL
#~# spaces_after_comma: :one

foo(1,2,3,x:1,y:2)

#~# EXPECTED

foo(1, 2, 3, x:1, y:2)

#~# ORIGINAL
#~# spaces_after_comma: :dynamic

foo(1,2,3,x:1,y:2)

#~# EXPECTED

foo(1,2,3,x:1,y:2)

#~# ORIGINAL
#~# spaces_after_comma: :one

def foo(x,y)
end

#~# EXPECTED

def foo(x, y)
end

#~# ORIGINAL
#~# spaces_after_comma: :dynamic

def foo(x,y)
end

#~# EXPECTED

def foo(x,y)
end

#~# ORIGINAL
#~# spaces_after_comma: :one

[1,  2,  3]

#~# EXPECTED

[1, 2, 3]

#~# ORIGINAL
#~# spaces_after_comma: :dynamic

[1,  2,  3]

#~# EXPECTED

[1,  2,  3]

#~# ORIGINAL
#~# spaces_after_comma: :one

[1,2,3]

#~# EXPECTED

[1, 2, 3]

#~# ORIGINAL
#~# spaces_after_comma: :dynamic

[1,2,3]

#~# EXPECTED

[1,2,3]

#~# ORIGINAL
#~# spaces_after_comma: :one

a  ,  b = 1,  2

#~# EXPECTED

a, b = 1, 2

#~# ORIGINAL
#~# spaces_after_comma: :dynamic

a  ,  b = 1,  2

#~# EXPECTED

a,  b = 1,  2

#~# ORIGINAL
#~# spaces_after_comma: :one

a,b = 1,2

#~# EXPECTED

a, b = 1, 2

#~# ORIGINAL
#~# spaces_after_comma: :dynamic

a,b = 1,2

#~# EXPECTED

a,b = 1,2

