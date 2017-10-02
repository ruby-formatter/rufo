#~# ORIGINAL

foo 1,  2,  3

#~# EXPECTED

foo 1, 2, 3

#~# ORIGINAL

foo(1,  2,  3)

#~# EXPECTED

foo(1, 2, 3)

#~# ORIGINAL

foo(1,2,3,x:1,y:2)

#~# EXPECTED

foo(1, 2, 3, x: 1, y: 2)

#~# ORIGINAL

def foo(x,y)
end

#~# EXPECTED

def foo(x, y)
end

#~# ORIGINAL

[1,  2,  3]

#~# EXPECTED

[1, 2, 3]

#~# ORIGINAL

[1,2,3]

#~# EXPECTED

[1, 2, 3]

#~# ORIGINAL

a  ,  b = 1,  2

#~# EXPECTED

a, b = 1, 2

#~# ORIGINAL

a,b = 1,2

#~# EXPECTED

a, b = 1, 2

