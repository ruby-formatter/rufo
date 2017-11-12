---
title: "squiggly\\_heredoc (v2.3 +)"
permalink: "/examples/squiggly_heredoc/"
toc: true
sidebar:
  nav: "examples"
---

### unnamed 742
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
### unnamed 743
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
### unnamed 744
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
### unnamed 745
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
### unnamed 746
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
### unnamed 747
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
### unnamed 748
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
### unnamed 749
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
### unnamed 750
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
### unnamed 751
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
### unnamed 752
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
