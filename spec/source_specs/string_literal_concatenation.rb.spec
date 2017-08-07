#~# ORIGINAL

"foo"   "bar"

#~# EXPECTED

"foo" "bar"

#~# ORIGINAL

"foo" \
 "bar"

#~# EXPECTED

"foo" \
"bar"

#~# ORIGINAL

x 1, "foo" \
     "bar"

#~# EXPECTED

x 1, "foo" \
     "bar"
