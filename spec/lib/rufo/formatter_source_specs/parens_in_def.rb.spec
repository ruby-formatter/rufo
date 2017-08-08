#~# ORIGINAL
#~# parens_in_def: :dynamic

def foo(x); end

#~# EXPECTED

def foo(x); end

#~# ORIGINAL
#~# parens_in_def: :dynamic

def foo x; end

#~# EXPECTED

def foo x; end

#~# ORIGINAL
#~# parens_in_def: :yes

def foo(x); end

#~# EXPECTED

def foo(x); end

#~# ORIGINAL
#~# parens_in_def: :yes

def foo x; end

#~# EXPECTED

def foo(x); end

