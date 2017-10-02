#~# ORIGINAL

a  =   1  ,   2

#~# EXPECTED

a = 1, 2

#~# ORIGINAL

a , b  = 2

#~# EXPECTED

a, b = 2

#~# ORIGINAL

a , b, ( c, d )  = 2

#~# EXPECTED

a, b, (c, d) = 2

#~# ORIGINAL

 *x = 1

#~# EXPECTED

*x = 1

#~# ORIGINAL

 a , b , *x = 1

#~# EXPECTED

a, b, *x = 1

#~# ORIGINAL

 *x , a , b = 1

#~# EXPECTED

*x, a, b = 1

#~# ORIGINAL

 a, b, *x, c, d = 1

#~# EXPECTED

a, b, *x, c, d = 1

#~# ORIGINAL

a, b, = 1

#~# EXPECTED

a, b, = 1

#~# ORIGINAL

a = b, *c

#~# EXPECTED

a = b, *c

#~# ORIGINAL

a = b, *c, *d

#~# EXPECTED

a = b, *c, *d

#~# ORIGINAL

a, = b

#~# EXPECTED

a, = b

#~# ORIGINAL

a = b, c, *d

#~# EXPECTED

a = b, c, *d

#~# ORIGINAL

a = b, c, *d, e

#~# EXPECTED

a = b, c, *d, e

#~# ORIGINAL

*, y = z

#~# EXPECTED

*, y = z

#~# ORIGINAL

w, (x,), y = z

#~# EXPECTED

w, (x,), y = z

#~# ORIGINAL

a, b=1, 2

#~# EXPECTED

a, b = 1, 2

#~# ORIGINAL

* = 1

#~# EXPECTED

* = 1
