#~# ORIGINAL simple dot

a.foo

#~# EXPECTED
a.foo

#~# ORIGINAL chained dots collapse spaces

foo . bar . baz

#~# EXPECTED
foo.bar.baz

#~# ORIGINAL safe navigation

a&.foo

#~# EXPECTED
a&.foo
