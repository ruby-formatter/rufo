#~# ORIGINAL

1 if 2

#~# EXPECTED

1 if 2

#~# ORIGINAL

1 unless 2

#~# EXPECTED

1 unless 2

#~# ORIGINAL

1 rescue 2

#~# EXPECTED

1 rescue 2

#~# ORIGINAL

1 while 2

#~# EXPECTED

1 while 2

#~# ORIGINAL

1 until 2

#~# EXPECTED

1 until 2

#~# ORIGINAL

x.y rescue z

#~# EXPECTED

x.y rescue z

#~# ORIGINAL

1  if  2

#~# EXPECTED

1 if 2

#~# ORIGINAL

foo bar(1)  if  2

#~# EXPECTED

foo bar(1) if 2
