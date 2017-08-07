#~# ORIGINAL 

 def foo . 
 bar; end

#~# EXPECTED

def foo.bar; end

#~# ORIGINAL 

 def self . 
 bar; end

#~# EXPECTED

def self.bar; end

