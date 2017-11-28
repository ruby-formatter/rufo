---
title: "squiggly\\_heredoc (v2.3 +)"
permalink: "/examples/squiggly_heredoc/"
toc: true
sidebar:
  nav: "examples"
---

### squiggly\_heredoc 1
```ruby
# GIVEN
[
  [<<~'},'] # comment
  },
]
```
```ruby
# BECOMES
[
  [<<~'},'], # comment
  },
]
```
```ruby
# with setting `trailing_commas false`
[
  [<<~'},'] # comment
  },
]
```
### squiggly\_heredoc 2
```ruby
# GIVEN
[
  [<<~'},'], # comment
  },
]
```
```ruby
# BECOMES
[
  [<<~'},'], # comment
  },
]
```
```ruby
# with setting `trailing_commas false`
[
  [<<~'},'] # comment
  },
]
```
### squiggly\_heredoc 3
```ruby
# GIVEN
[
  [<<~'},'], # comment
  },
  2,
]
```
```ruby
# BECOMES
[
  [<<~'},'], # comment
  },
  2,
]
```
```ruby
# with setting `trailing_commas false`
[
  [<<~'},'], # comment
  },
  2
]
```
### squiggly\_heredoc 4
```ruby
# GIVEN
[
  [<<~EOF] # comment
  EOF
]
```
```ruby
# BECOMES
[
  [<<~EOF], # comment
  EOF
]
```
```ruby
# with setting `trailing_commas false`
[
  [<<~EOF] # comment
  EOF
]
```
### squiggly\_heredoc 5
```ruby
# GIVEN
begin
  foo = <<~STR
    some

    thing
  STR
end
```
```ruby
# BECOMES
begin
  foo = <<~STR
    some

    thing
  STR
end
```
### squiggly\_heredoc 6
```ruby
# GIVEN
<<~EOF
  foo
   bar
EOF
```
```ruby
# BECOMES
<<~EOF
  foo
   bar
EOF
```
### squiggly\_heredoc 7
```ruby
# GIVEN
<<~EOF
  #{1}
  #{2}
   bar
   baz
EOF
```
```ruby
# BECOMES
<<~EOF
  #{1}
  #{2}
   bar
   baz
EOF
```
### squiggly\_heredoc 8
```ruby
# GIVEN
<<~EOF
  #{1}
   #{2}
   bar
    baz
EOF
```
```ruby
# BECOMES
<<~EOF
  #{1}
   #{2}
   bar
    baz
EOF
```
### squiggly\_heredoc 9
```ruby
# GIVEN
<<~EOF
  #{1}
  foo
  #{2}
  bar
  #{3}
  baz
EOF
```
```ruby
# BECOMES
<<~EOF
  #{1}
  foo
  #{2}
  bar
  #{3}
  baz
EOF
```
### squiggly\_heredoc 10
```ruby
# GIVEN
<<~EOF
  #{1}
   foo
  #{2}
    bar
  #{3}
     baz
EOF
```
```ruby
# BECOMES
<<~EOF
  #{1}
   foo
  #{2}
    bar
  #{3}
     baz
EOF
```
### squiggly\_heredoc 11
```ruby
# GIVEN
begin
 <<~EOF
  foo
   bar
EOF
 end
```
```ruby
# BECOMES
begin
  <<~EOF
    foo
     bar
  EOF
end
```
### heredoc_squiggly_no_leading_space
```ruby
# GIVEN
<<~EOF
a
EOF
```
```ruby
# BECOMES
<<~EOF
  a
EOF
```
### heredoc_squiggly_extra_spaces
```ruby
# GIVEN
<<~EOF
#{1} #{2}
EOF
```
```ruby
# BECOMES
<<~EOF
#{1} #{2}
EOF
```
### heredoc_squiggly_extra_spaces_2
```ruby
# GIVEN
<<~EOF
  #{1}      #{2}
EOF
```
```ruby
# BECOMES
<<~EOF
  #{1}      #{2}
EOF
```
### heredoc_squiggly_extra_spaces_3
```ruby
# GIVEN
<<~EOF
  #{1}#{2}
EOF
```
```ruby
# BECOMES
<<~EOF
  #{1}#{2}
EOF
```
### heredoc_squiggly_extra_spaces_4
```ruby
# GIVEN
<<~EOF
 #{1}#{2}
EOF
```
```ruby
# BECOMES
<<~EOF
  #{1}#{2}
EOF
```
