---
title: "heredoc"
permalink: "/examples/heredoc/"
toc: true
sidebar:
  nav: "examples"
---

### heredoc
```ruby
# GIVEN
<<-EOF
  foo
  bar
EOF
```
```ruby
# BECOMES
<<-EOF
  foo
  bar
EOF
```
### heredoc_multiline
```ruby
# GIVEN
foo 1 , <<-EOF , 2
  foo
  bar
EOF
```
```ruby
# BECOMES
foo 1, <<-EOF, 2
  foo
  bar
EOF
```
### heredoc_multiline_2
```ruby
# GIVEN
foo 1 , <<-EOF1 , 2 , <<-EOF2 , 3
  foo
  bar
EOF1
  baz
EOF2
```
```ruby
# BECOMES
foo 1, <<-EOF1, 2, <<-EOF2, 3
  foo
  bar
EOF1
  baz
EOF2
```
### heredoc_multiline_3
```ruby
# GIVEN
foo 1 , <<-EOF1 , 2 , <<-EOF2
  foo
  bar
EOF1
  baz
EOF2
```
```ruby
# BECOMES
foo 1, <<-EOF1, 2, <<-EOF2
  foo
  bar
EOF1
  baz
EOF2
```
### heredoc_inside_method_call
```ruby
# GIVEN
foo(1 , <<-EOF , 2 )
  foo
  bar
EOF
```
```ruby
# BECOMES
foo(1, <<-EOF, 2)
  foo
  bar
EOF
```
### heredoc_with_method_called
```ruby
# GIVEN
<<-EOF.foo
  bar
EOF
```
```ruby
# BECOMES
<<-EOF.foo
  bar
EOF
```
### heredoc_assigned_to_variable
```ruby
# GIVEN
x = <<-EOF.foo
  bar
EOF
```
```ruby
# BECOMES
x = <<-EOF.foo
  bar
EOF
```
### heredoc_assigned_to_multiple_variables
```ruby
# GIVEN
x, y = <<-EOF.foo, 2
  bar
EOF
```
```ruby
# BECOMES
x, y = <<-EOF.foo, 2
  bar
EOF
```
### heredoc_as_method_argument
```ruby
# GIVEN
call <<-EOF.foo, y
  bar
EOF
```
```ruby
# BECOMES
call <<-EOF.foo, y
  bar
EOF
```
### heredoc_as_method_argument_with_brackets
```ruby
# GIVEN
foo(<<-EOF
  foo
  bar
  EOF
  )
```
```ruby
# BECOMES
foo(<<-EOF
  foo
  bar
  EOF
)
```
### heredoc_with_trailing_comment
```ruby
# GIVEN
<<-EOF
  foo
EOF

# comment
```
```ruby
# BECOMES
<<-EOF
  foo
EOF

# comment
```
### heredoc_as_strange_method_argument
```ruby
# GIVEN
foo(<<-EOF)
  bar
EOF
```
```ruby
# BECOMES
foo(<<-EOF)
  bar
EOF
```
### heredoc_with_bizarre_syntax
```ruby
# GIVEN
foo <<-EOF.bar if 1
  x
EOF
```
```ruby
# BECOMES
foo <<-EOF.bar if 1
  x
EOF
```
### heredoc_with_percent
```ruby
# GIVEN
<<-EOF % 1
  bar
EOF
```
```ruby
# BECOMES
<<-EOF % 1
  bar
EOF
```
### heredoc_as_hash_value
```ruby
# GIVEN
{1 => <<EOF,
text
EOF
 2 => 3}
```
```ruby
# BECOMES
{1 => <<EOF,
text
EOF
 2 => 3}
```
