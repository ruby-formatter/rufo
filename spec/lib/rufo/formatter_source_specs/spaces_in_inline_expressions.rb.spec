#~# ORIGINAL

begin end

#~# EXPECTED

begin end

#~# ORIGINAL

begin  1  end

#~# EXPECTED

begin 1 end

#~# ORIGINAL

def foo()  1  end

#~# EXPECTED

def foo() 1 end

#~# ORIGINAL

def foo(x)  1  end

#~# EXPECTED

def foo(x) 1 end

#~# ORIGINAL

def foo1(x) 1 end
 def foo2(x) 2 end
  def foo3(x) 3 end

#~# EXPECTED

def foo1(x) 1 end
def foo2(x) 2 end
def foo3(x) 3 end

