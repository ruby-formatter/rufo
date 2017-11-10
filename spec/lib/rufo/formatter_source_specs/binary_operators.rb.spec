#~# ORIGINAL

1   +   2

#~# EXPECTED

1 + 2

#~# ORIGINAL

1+2

#~# EXPECTED

1 + 2

#~# ORIGINAL

1   +
 2

#~# EXPECTED

1 +
  2

#~# ORIGINAL

1   +  # hello
 2

#~# EXPECTED

1 + # hello
  2

#~# ORIGINAL

1 +
 2+
 3

#~# EXPECTED

1 +
  2 +
  3

#~# ORIGINAL

1  &&  2

#~# EXPECTED

1 && 2

#~# ORIGINAL

1  ||  2

#~# EXPECTED

1 || 2

#~# ORIGINAL

1*2

#~# EXPECTED

1 * 2

#~# ORIGINAL

1* 2

#~# EXPECTED

1 * 2

#~# ORIGINAL

1 *2

#~# EXPECTED

1 * 2

#~# ORIGINAL

1/2

#~# EXPECTED

1 / 2

#~# ORIGINAL

1**2

#~# EXPECTED

1 ** 2

#~# ORIGINAL

1 \
 + 2

#~# EXPECTED

1 \
  + 2

#~# ORIGINAL

a = 1 ||
2

#~# EXPECTED

a = 1 ||
    2

#~# ORIGINAL

1 ||
2

#~# EXPECTED

1 ||
2
