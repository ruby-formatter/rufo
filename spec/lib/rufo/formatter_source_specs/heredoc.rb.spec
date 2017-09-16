#~# ORIGINAL heredoc

<<-EOF
  foo
  bar
EOF

#~# EXPECTED

<<-EOF
  foo
  bar
EOF

#~# ORIGINAL heredoc_multiline

foo 1 , <<-EOF , 2
  foo
  bar
EOF

#~# EXPECTED

foo 1, <<-EOF, 2
  foo
  bar
EOF

#~# ORIGINAL heredoc_multiline_2

foo 1 , <<-EOF1 , 2 , <<-EOF2 , 3
  foo
  bar
EOF1
  baz
EOF2

#~# EXPECTED

foo 1, <<-EOF1, 2, <<-EOF2, 3
  foo
  bar
EOF1
  baz
EOF2

#~# ORIGINAL heredoc_multiline_3

foo 1 , <<-EOF1 , 2 , <<-EOF2
  foo
  bar
EOF1
  baz
EOF2

#~# EXPECTED

foo 1, <<-EOF1, 2, <<-EOF2
  foo
  bar
EOF1
  baz
EOF2

#~# ORIGINAL heredoc_inside_method_call

foo(1 , <<-EOF , 2 )
  foo
  bar
EOF

#~# EXPECTED

foo(1, <<-EOF, 2)
  foo
  bar
EOF

#~# ORIGINAL heredoc_with_method_called

<<-EOF.foo
  bar
EOF

#~# EXPECTED

<<-EOF.foo
  bar
EOF

#~# ORIGINAL heredoc_assigned_to_variable

x = <<-EOF.foo
  bar
EOF

#~# EXPECTED

x = <<-EOF.foo
  bar
EOF

#~# ORIGINAL heredoc_assigned_to_multiple_variables

x, y = <<-EOF.foo, 2
  bar
EOF

#~# EXPECTED

x, y = <<-EOF.foo, 2
  bar
EOF

#~# ORIGINAL heredoc_as_method_argument

call <<-EOF.foo, y
  bar
EOF

#~# EXPECTED

call <<-EOF.foo, y
  bar
EOF

#~# ORIGINAL heredoc_as_method_argument_with_brackets

foo(<<-EOF
  foo
  bar
  EOF
  )

#~# EXPECTED

foo(<<-EOF
  foo
  bar
  EOF
)

#~# ORIGINAL heredoc_with_trailing_comment

<<-EOF
  foo
EOF

# comment

#~# EXPECTED

<<-EOF
  foo
EOF

# comment

#~# ORIGINAL heredoc_as_strange_method_argument

foo(<<-EOF)
  bar
EOF

#~# EXPECTED

foo(<<-EOF)
  bar
EOF

#~# ORIGINAL heredoc_with_bizarre_syntax

foo <<-EOF.bar if 1
  x
EOF

#~# EXPECTED

foo <<-EOF.bar if 1
  x
EOF

#~# ORIGINAL heredoc_with_percent

<<-EOF % 1
  bar
EOF

#~# EXPECTED

<<-EOF % 1
  bar
EOF

#~# ORIGINAL heredoc_as_hash_value

{1 => <<EOF,
text
EOF
 2 => 3}

#~# EXPECTED

{1 => <<EOF,
text
EOF
 2 => 3}

#~# ORIGINAL heredoc_squiggly_no_leading_space

<<~EOF
a
EOF

#~# EXPECTED

<<~EOF
  a
EOF

#~# ORIGINAL heredoc_squiggly_extra_spaces
#~# PENDING

<<~EOF
#{1} #{2}
EOF

#~# EXPECTED

<<~EOF
#{1 }#{2}
EOF
