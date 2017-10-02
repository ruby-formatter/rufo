#~# ORIGINAL

a=1

#~# EXPECTED

a = 1

#~# ORIGINAL

a  =  1

#~# EXPECTED

a = 1

#~# ORIGINAL

a  =  1

#~# EXPECTED

a = 1

#~# ORIGINAL

a+=1

#~# EXPECTED

a += 1

#~# ORIGINAL

a  +=  1

#~# EXPECTED

a += 1

#~# ORIGINAL

a  +=  1

#~# EXPECTED

a += 1

#~# ORIGINAL

def foo(x  =  1)
end

#~# EXPECTED

def foo(x = 1)
end

#~# ORIGINAL

def foo(x=1)
end

#~# EXPECTED

def foo(x = 1)
end
