#~# ORIGINAL  no_keywords_accepted
def foo(*args, **nil)
end

#~# EXPECTED
def foo(*args, **nil)
end

#~# ORIGINAL  forward_args
def foo(...)
  p(...)
end

#~# EXPECTED
def foo(...)
  p(...)
end
