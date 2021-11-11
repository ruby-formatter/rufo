#~# ORIGINAL  partial_forward_args
def foo(a,    ...)
  p(...)
end

#~# EXPECTED
def foo(a, ...)
  p(...)
end
