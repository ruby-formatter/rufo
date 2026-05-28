#~# ORIGINAL

def foo
end
def bar
end

#~# EXPECTED
def foo
end

def bar
end

#~# ORIGINAL

class Foo
end
class Bar
end

#~# EXPECTED
class Foo
end

class Bar
end

#~# ORIGINAL

module Foo
end
module Bar
end

#~# EXPECTED
module Foo
end

module Bar
end

#~# ORIGINAL

1
def foo
end

#~# EXPECTED
1

def foo
end

#~# ORIGINAL issue 357 receiver preserved after comment in parens
a=(#X
1)

[STDOUT].each{ |elem| elem.puts [
    2
  ]
}

#~# EXPECTED
a = ( #X
  1)

[STDOUT].each { |elem|
  elem.puts [
    2,
  ]
}
