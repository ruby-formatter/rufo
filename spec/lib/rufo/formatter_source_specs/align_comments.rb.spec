#~# ORIGINAL
#~# align_comments: true

1 # one 
 123 # two

#~# EXPECTED

1   # one
123 # two

#~# ORIGINAL
#~# align_comments: true

1 # one 
 123 # two 
 4 
 5 # lala

#~# EXPECTED

1   # one
123 # two
4
5 # lala

#~# ORIGINAL
#~# align_comments: true

foobar( # one 
 1 # two 
)

#~# EXPECTED

foobar( # one
  1     # two
)

#~# ORIGINAL
#~# align_assignments: true, align_comments: true

a = 1 # foo
 abc = 2 # bar

#~# EXPECTED

a   = 1 # foo
abc = 2 # bar

#~# ORIGINAL
#~# align_comments: true

a = 1 # foo
      # bar

#~# EXPECTED

a = 1 # foo
      # bar

#~# ORIGINAL
#~# align_comments: true

# foo
a # bar

#~# EXPECTED

# foo
a # bar

#~# ORIGINAL
#~# align_comments: true

 # foo
a # bar

#~# EXPECTED

# foo
a # bar

#~# ORIGINAL
#~# align_comments: true

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
#~# align_comments: true

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
#~# align_comments: true

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
#~# align_comments: false

1 # one
 123 # two

#~# EXPECTED

1 # one
123 # two

#~# ORIGINAL
#~# align_comments: true

foo bar( # foo
  1,     # bar
)

#~# EXPECTED

foo bar( # foo
  1,     # bar
)

#~# ORIGINAL
#~# align_comments: false

a = 1   # foo
bar = 2 # baz

#~# EXPECTED

a = 1   # foo
bar = 2 # baz

#~# ORIGINAL
#~# align_comments: false

[
  1,   # foo
  234,   # bar
]

#~# EXPECTED

[
  1,   # foo
  234,   # bar
]

#~# ORIGINAL
#~# align_comments: false

[
  1,   # foo
  234    # bar
]

#~# EXPECTED

[
  1,   # foo
  234    # bar
]

#~# ORIGINAL
#~# align_comments: false

foo bar: 1,  # comment
    baz: 2    # comment

#~# EXPECTED

foo bar: 1,  # comment
    baz: 2    # comment

