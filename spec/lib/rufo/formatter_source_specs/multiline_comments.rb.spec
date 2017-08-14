#~# ORIGINAL multiline_comment

=begin
  foo
  bar
=end

#~# EXPECTED

=begin
  foo
  bar
=end

#~# ORIGINAL multiline_comment_2

1

=begin
  foo
  bar
=end

2

#~# EXPECTED

1

=begin
  foo
  bar
=end

2

#~# ORIGINAL multiline_comment_3

# foo
=begin
bar
=end

#~# EXPECTED

# foo
=begin
bar
=end
