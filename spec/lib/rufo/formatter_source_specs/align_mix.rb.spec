#~# ORIGINAL

abc = 1
a = {foo: 1, # comment
 bar: 2} # another

#~# EXPECTED

abc = 1
a = { foo: 1, # comment
      bar: 2 } # another

#~# ORIGINAL

abc = 1
a = {foobar: 1, # comment
 bar: 2} # another

#~# EXPECTED

abc = 1
a = { foobar: 1, # comment
      bar: 2 } # another

