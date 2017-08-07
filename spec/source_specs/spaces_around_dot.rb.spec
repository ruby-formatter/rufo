#~# ORIGINAL
#~# spaces_around_dot: :dynamic

foo . bar

#~# EXPECTED

foo . bar

#~# ORIGINAL
#~# spaces_around_dot: :dynamic

foo . bar = 1

#~# EXPECTED

foo . bar = 1

#~# ORIGINAL
#~# spaces_around_dot: :no

foo . bar

#~# EXPECTED

foo.bar

#~# ORIGINAL
#~# spaces_around_dot: :no

foo . bar = 1

#~# EXPECTED

foo.bar = 1

