#~# ORIGINAL
#~# spaces_after_method_name: :no

def foo  (x)
end

#~# EXPECTED

def foo(x)
end

#~# ORIGINAL
#~# spaces_after_method_name: :dynamic

def foo  (x)
end

#~# EXPECTED

def foo  (x)
end

#~# ORIGINAL
#~# spaces_after_method_name: :no

def self.foo  (x)
end

#~# EXPECTED

def self.foo(x)
end

#~# ORIGINAL
#~# spaces_after_method_name: :dynamic

def self.foo  (x)
end

#~# EXPECTED

def self.foo  (x)
end

