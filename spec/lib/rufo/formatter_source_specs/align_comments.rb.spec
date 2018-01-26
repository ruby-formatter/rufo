#~# ORIGINAL

1 # one
 123 # two

#~# EXPECTED

1 # one
123 # two

#~# ORIGINAL

1 # one
 123 # two
 4
 5 # lala

#~# EXPECTED

1 # one
123 # two
4
5 # lala

#~# ORIGINAL

foobar( # one
 1 # two
)

#~# EXPECTED

foobar( # one
  1 # two
)

#~# ORIGINAL

a = 1 # foo
 abc = 2 # bar

#~# EXPECTED

a = 1 # foo
abc = 2 # bar

#~# ORIGINAL

a = 1 # foo
      # bar

#~# EXPECTED

a = 1 # foo
      # bar

#~# ORIGINAL

# foo
a # bar

#~# EXPECTED

# foo
a # bar

#~# ORIGINAL

 # foo
a # bar

#~# EXPECTED

# foo
a # bar

#~# ORIGINAL

require x

# Comment 1
# Comment 2
FOO = :bar # Comment 3

#~# EXPECTED

require x

# Comment 1
# Comment 2
FOO = :bar # Comment 3

#~# ORIGINAL

begin
  require x

  # Comment 1
  # Comment 2
  FOO = :bar # Comment 3
end

#~# EXPECTED

begin
  require x

  # Comment 1
  # Comment 2
  FOO = :bar # Comment 3
end

#~# ORIGINAL

begin
  a     # c1
        # c2
  b = 1 # c3
end

#~# EXPECTED

begin
  a     # c1
        # c2
  b = 1 # c3
end

#~# ORIGINAL

1 # one
 123 # two

#~# EXPECTED

1 # one
123 # two

#~# ORIGINAL

foo bar( # foo
  1,     # bar
)

#~# EXPECTED

foo bar( # foo
  1,     # bar
)

#~# ORIGINAL

a = 1   # foo
bar = 2 # baz

#~# EXPECTED

a = 1   # foo
bar = 2 # baz

#~# ORIGINAL

[
  1,   # foo
  234,   # bar
]

#~# EXPECTED

[
  1, # foo
  234, # bar
]

#~# ORIGINAL

[
  1,   # foo
  234    # bar
]

#~# EXPECTED

[
  1, # foo
  234, # bar
]

#~# ORIGINAL

foo bar: 1,  # comment
    baz: 2    # comment

#~# EXPECTED

foo bar: 1,  # comment
    baz: 2    # comment

