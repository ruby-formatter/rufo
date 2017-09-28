#~# ORIGINAL
#~# align_hash_keys: true, align_comments: true

abc = 1
a = {foo: 1, # comment
 bar: 2} # another

#~# EXPECTED

abc = 1
a = {foo: 1, # comment
     bar: 2} # another

#~# ORIGINAL
#~# align_hash_keys: true, align_comments: true

abc = 1
a = {foobar: 1, # comment
 bar: 2} # another

#~# EXPECTED

abc = 1
a = {foobar: 1, # comment
     bar:    2} # another

