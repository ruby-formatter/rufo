#~# ORIGINAL  anonymous_block_variable
def foo(  &)
  bar(&)
end

#~# EXPECTED
def foo(&)
  bar(&)
end
