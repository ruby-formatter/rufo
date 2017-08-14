#~# ORIGINAL 

a += 2

#~# EXPECTED

a += 2

#~# ORIGINAL 

a += 
 2

#~# EXPECTED

a += 2

#~# ORIGINAL 

a+=1

#~# EXPECTED

a += 1

#~# ORIGINAL plus equals on string

a='hello'
a+='dma'

#~# EXPECTED

a = 'hello'
a += 'dma'
