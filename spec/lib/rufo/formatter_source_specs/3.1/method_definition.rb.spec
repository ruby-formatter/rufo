#~# ORIGINAL  anonymous_block_variable
def foo(  &   )
  bar(  &      )
end

#~# EXPECTED
def foo(&)
  bar(&)
end

#~# ORIGINAL
def foo(a , &)
  bar(a , &)
end

#~# EXPECTED
def foo(a, &)
  bar(a, &)
end

#~# ORIGINAL

def foo(y, &)
  x(*y, &z)
end

#~# EXPECTED
def foo(y, &)
  x(*y, &z)
end

#~# ORIGINAL
def foo(
  a,
  &
)
bar(
  a,
  &
)
end

#~# EXPECTED
def foo(
  a,
  &
)
  bar(
    a,
    &
  )
end

#~# ORIGINAL

  def foo( a: 1,
 & )
 end

#~# EXPECTED
def foo(a: 1,
        &)
end

#~# ORIGINAL issue_332

def foo(&)
  hoge(
      **a,
  &
  )
  end

#~# EXPECTED
def foo(&)
  hoge(
    **a,
    &
  )
end
