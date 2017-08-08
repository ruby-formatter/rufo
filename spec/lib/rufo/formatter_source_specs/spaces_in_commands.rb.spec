#~# ORIGINAL
#~# spaces_in_commands: :one

foo  1

#~# EXPECTED

foo 1

#~# ORIGINAL
#~# spaces_in_commands: :one

foo.bar  1

#~# EXPECTED

foo.bar 1

#~# ORIGINAL
#~# spaces_in_commands: :dynamic

not x

#~# EXPECTED

not x

#~# ORIGINAL
#~# spaces_in_commands: :dynamic

not  x

#~# EXPECTED

not  x

#~# ORIGINAL
#~# spaces_in_commands: :one

not x

#~# EXPECTED

not x

#~# ORIGINAL
#~# spaces_in_commands: :one

not  x

#~# EXPECTED

not x

#~# ORIGINAL
#~# spaces_in_commands: :dynamic

defined? 1

#~# EXPECTED

defined? 1

#~# ORIGINAL
#~# spaces_in_commands: :dynamic

defined?  1

#~# EXPECTED

defined?  1

#~# ORIGINAL
#~# spaces_in_commands: :one

defined?  1

#~# EXPECTED

defined? 1

