#~# ORIGINAL skip
#~# align_assignments: true, align_hash_keys: true, align_comments: true

abc = 1
a = {foo: 1, # comment
 bar: 2} # another

#~# EXPECTED

abc = 1
a   = {foo: 1, # comment
       bar: 2} # another

#~# ORIGINAL skip
#~# align_assignments: true, align_hash_keys: true, align_comments: true

abc = 1
a = {foobar: 1, # comment
 bar: 2} # another

#~# EXPECTED

abc = 1
a   = {foobar: 1, # comment
       bar:    2} # another

