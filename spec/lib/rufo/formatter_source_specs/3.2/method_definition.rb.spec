#~# ORIGINAL  anonymous_splat_forwarding
def foo(    * )
  p(*  )
end

#~# EXPECTED
def foo(*)
  p(*)
end

#~# ORIGINAL  anonymous_kwargs_forwarding
def foo(    ** )
  p( **  )
end

#~# EXPECTED
def foo(**)
  p(**)
end

#~# ORIGINAL  anonymous_splat_and_kwargs_forwarding
def foo( * , ** )
  p( * , ** )
end

#~# EXPECTED
def foo(*, **)
  p(*, **)
end
