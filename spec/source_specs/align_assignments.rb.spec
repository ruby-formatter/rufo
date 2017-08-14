#~# ORIGINAL skip
#~# align_assignments: true

x = 1 
 xyz = 2

 w = 3

#~# EXPECTED

x   = 1
xyz = 2

w = 3

#~# ORIGINAL skip
#~# align_assignments: true

x = 1 
 foo[bar] = 2

 w = 3

#~# EXPECTED

x        = 1
foo[bar] = 2

w = 3

#~# ORIGINAL skip
#~# align_assignments: true

x = 1; x = 2 
 xyz = 2

 w = 3

#~# EXPECTED

x   = 1; x = 2
xyz = 2

w = 3

#~# ORIGINAL skip
#~# align_assignments: true

a = begin
 b = 1 
 abc = 2 
 end

#~# EXPECTED

a = begin
  b   = 1
  abc = 2
end

#~# ORIGINAL skip
#~# align_assignments: true

a = 1
 a += 2

#~# EXPECTED

a  = 1
a += 2

#~# ORIGINAL skip
#~# align_assignments: true

foo = 1
 a += 2

#~# EXPECTED

foo = 1
a  += 2

#~# ORIGINAL skip
#~# align_assignments: false

x = 1 
 xyz = 2

 w = 3

#~# EXPECTED

x = 1
xyz = 2

w = 3

