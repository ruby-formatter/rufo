#~# ORIGINAL 

foo.()

#~# EXPECTED

foo.()

#~# ORIGINAL 

foo.( 1 )

#~# EXPECTED

foo.(1)

#~# ORIGINAL 

foo.( 1, 2 )

#~# EXPECTED

foo.(1, 2)

#~# ORIGINAL 

x.foo.( 1, 2 )

#~# EXPECTED

x.foo.(1, 2)
