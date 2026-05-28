#~# ORIGINAL standalone single

# foo

#~# EXPECTED
# foo

#~# ORIGINAL two consecutive standalones

# foo
# bar

#~# EXPECTED
# foo
# bar

#~# ORIGINAL trailing after integer

1   # foo

#~# EXPECTED
1   # foo

#~# ORIGINAL standalone before code

# a
1

#~# EXPECTED
# a
1

#~# ORIGINAL trailing then standalone

1 # a
# b

#~# EXPECTED
1 # a
# b
