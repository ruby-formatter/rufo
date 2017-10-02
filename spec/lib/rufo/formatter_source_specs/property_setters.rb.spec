#~# ORIGINAL

foo . bar  =  1

#~# EXPECTED

foo.bar = 1

#~# ORIGINAL

foo . bar  =
 1

#~# EXPECTED

foo.bar =
  1

#~# ORIGINAL

foo .
 bar  =
 1

#~# EXPECTED

foo.
  bar =
  1

#~# ORIGINAL

foo:: bar  =  1

#~# EXPECTED

foo::bar = 1

#~# ORIGINAL

foo:: bar  =
 1

#~# EXPECTED

foo::bar =
  1

#~# ORIGINAL

foo::
 bar  =
 1

#~# EXPECTED

foo::
  bar =
  1
