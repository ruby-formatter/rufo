#~# ORIGINAL

private

foo
bar

#~# EXPECTED

private

foo
bar

#~# ORIGINAL

private

  foo
bar

#~# EXPECTED

private

foo
bar

#~# ORIGINAL

private

  foo
bar

protected

  baz

#~# EXPECTED

private

foo
bar

protected

baz

#~# ORIGINAL

private

  foo
bar

protected

  baz

#~# EXPECTED

private

foo
bar

protected

baz

#~# ORIGINAL

class Foo
  private

    foo
end

#~# EXPECTED

class Foo
  private

  foo
end

#~# ORIGINAL

class << self
  private

    foo
end

#~# EXPECTED

class << self
  private

  foo
end

