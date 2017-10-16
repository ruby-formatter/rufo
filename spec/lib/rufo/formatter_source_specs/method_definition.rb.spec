#~# ORIGINAL

  def foo
 end

#~# EXPECTED

def foo
end

#~# ORIGINAL

  def foo ; end

#~# EXPECTED

def foo; end

#~# ORIGINAL

  def foo()
 end

#~# EXPECTED

def foo()
end

#~# ORIGINAL

  def foo() 1 end

#~# EXPECTED

def foo() 1 end

#~# ORIGINAL

  def foo(
 )
 end

#~# EXPECTED

def foo()
end

#~# ORIGINAL

  def foo( x )
 end

#~# EXPECTED

def foo(x)
end

#~# ORIGINAL

  def foo( x , y )
 end

#~# EXPECTED

def foo(x, y)
end

#~# ORIGINAL

  def foo x
 end

#~# EXPECTED

def foo(x)
end

#~# ORIGINAL

  def foo x , y
 end

#~# EXPECTED

def foo(x, y)
end

#~# ORIGINAL

  def foo
 1
 end

#~# EXPECTED

def foo
  1
end

#~# ORIGINAL

  def foo( * x )
 1
 end

#~# EXPECTED

def foo(*x)
  1
end

#~# ORIGINAL

  def foo( a , * x )
 1
 end

#~# EXPECTED

def foo(a, *x)
  1
end

#~# ORIGINAL

  def foo( a , * x, b )
 1
 end

#~# EXPECTED

def foo(a, *x, b)
  1
end

#~# ORIGINAL

  def foo( x  =  1 )
 end

#~# EXPECTED

def foo(x = 1)
end

#~# ORIGINAL

  def foo( x  =  1, * y )
 end

#~# EXPECTED

def foo(x = 1, *y)
end

#~# ORIGINAL

  def foo( & block )
 end

#~# EXPECTED

def foo(&block)
end

#~# ORIGINAL

  def foo( a: , b: )
 end

#~# EXPECTED

def foo(a:, b:)
end

#~# ORIGINAL

  def foo( a: 1 , b: 2  )
 end

#~# EXPECTED

def foo(a: 1, b: 2)
end

#~# ORIGINAL

  def foo( x,
 y )
 end

#~# EXPECTED

def foo(x,
        y)
end

#~# ORIGINAL

  def foo( a: 1,
 b: 2 )
 end

#~# EXPECTED

def foo(a: 1,
        b: 2)
end

#~# ORIGINAL

  def foo(
 x,
 y )
 end

#~# EXPECTED

def foo(
        x,
        y)
end

#~# ORIGINAL

  def foo( a: 1, &block )
 end

#~# EXPECTED

def foo(a: 1, &block)
end

#~# ORIGINAL

  def foo( a: 1,
 &block )
 end

#~# EXPECTED

def foo(a: 1,
        &block)
end

#~# ORIGINAL

  def foo(*)
 end

#~# EXPECTED

def foo(*)
end

#~# ORIGINAL

  def foo(**)
 end

#~# EXPECTED

def foo(**)
end

#~# ORIGINAL

def `(cmd)
end

#~# EXPECTED

def `(cmd)
end

#~# ORIGINAL

module_function def foo
  1
end

#~# EXPECTED

module_function def foo
  1
end

#~# ORIGINAL

private def foo
  1
end

#~# EXPECTED

private def foo
  1
end

#~# ORIGINAL

some class Foo
  1
end

#~# EXPECTED

some class Foo
  1
end

#~# ORIGINAL

def foo; 1; end
def bar; 2; end

#~# EXPECTED

def foo; 1; end
def bar; 2; end

#~# ORIGINAL

def foo; 1; end

def bar; 2; end

#~# EXPECTED

def foo; 1; end

def bar; 2; end
