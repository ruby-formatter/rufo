#~# ORIGINAL
#~# visibility_indent: :dynamic

private

foo
bar

#~# EXPECTED

private

foo
bar

#~# ORIGINAL
#~# visibility_indent: :dynamic

private

  foo
bar

#~# EXPECTED

private

  foo
  bar

#~# ORIGINAL
#~# visibility_indent: :align

private

  foo
bar

#~# EXPECTED

private

foo
bar

#~# ORIGINAL
#~# visibility_indent: :indent

private

foo
bar

#~# EXPECTED

private

  foo
  bar

#~# ORIGINAL
#~# visibility_indent: :dynamic

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
#~# visibility_indent: :indent

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
#~# visibility_indent: :align

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
#~# visibility_indent: :dynamic

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
#~# visibility_indent: :dynamic

class << self
  private

    foo
end

#~# EXPECTED

class << self
  private

    foo
end

