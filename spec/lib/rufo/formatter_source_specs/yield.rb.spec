#~# ORIGINAL yield
def foo

yield
end

#~# EXPECTED
def foo
  yield
end

#~# ORIGINAL
def foo

yield  1
end

#~# EXPECTED
def foo
  yield 1
end

#~# ORIGINAL
def foo

yield  1 , 2
end

#~# EXPECTED
def foo
  yield 1, 2
end

#~# ORIGINAL
def foo

yield  1 ,
 2
end

#~# EXPECTED
def foo
  yield 1,
        2
end

#~# ORIGINAL
def foo

yield( 1 , 2 )
end

#~# EXPECTED
def foo
  yield(1, 2)
end
