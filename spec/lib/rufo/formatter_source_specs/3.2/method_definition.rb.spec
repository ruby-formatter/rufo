#~# ORIGINAL  anonymous_rest_args_forwarding
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

#~# ORIGINAL  anonymous_rest_and_kwargs_forwarding
def foo( * , ** )
  p( * , ** )
end

#~# EXPECTED
def foo(*, **)
  p(*, **)
end
