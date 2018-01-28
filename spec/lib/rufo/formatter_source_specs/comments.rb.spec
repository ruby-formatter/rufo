#~# ORIGINAL comment

# foo

#~# EXPECTED

# foo

#~# ORIGINAL two_comments

# foo
# bar

#~# EXPECTED

# foo
# bar

#~# ORIGINAL integer_with_comment

1   # foo

#~# EXPECTED

1   # foo

#~# ORIGINAL comment_with_double_line_break

# a

# b

#~# EXPECTED

# a

# b

#~# ORIGINAL comment_with_triple_line_break

# a


# b

#~# EXPECTED

# a

# b

#~# ORIGINAL comment_and_integer

# a
1

#~# EXPECTED

# a
1

#~# ORIGINAL comment_double_newline_integer

# a


1

#~# EXPECTED

# a

1

#~# ORIGINAL integer_with_comment_and_following_comment

1 # a
# b

#~# EXPECTED

1 # a
# b

#~# ORIGINAL integer_with_comment_and_multiline_break

1 # a

# b

#~# EXPECTED

1 # a

# b

#~# ORIGINAL integers_separated_by_comments

1 # a

2 # b

#~# EXPECTED

1 # a

2 # b

#~# ORIGINAL multiple_trailing_comments

1 # a


2 # b

#~# EXPECTED

1 # a

2 # b

#~# ORIGINAL more_trailing_comments

1 # a






2 # b

#~# EXPECTED

1 # a

2 # b

#~# ORIGINAL still_more_trailing_comments

1 # a


# b


 # c
 2 # b

#~# EXPECTED

1 # a

# b

# c
2 # b

#~# ORIGINAL comment_indentation_inside_method_call

foo(
# comment for foo
foo: "foo"
)

#~# EXPECTED

foo(
  # comment for foo
  foo: "foo",
)

#~# ORIGINAL comment_indentation_inside_method_call_2

foo(
 # comment for foo
foo: "foo"
)

#~# EXPECTED

foo(
  # comment for foo
  foo: "foo",
)

#~# ORIGINAL comment_indentation_inside_method_call_3

foo(
  # comment for foo
foo: "foo"
)

#~# EXPECTED

foo(
  # comment for foo
  foo: "foo",
)

#~# ORIGINAL comment_indentation_inside_method_call_4

foo(
   # comment for foo
foo: "foo"
)

#~# EXPECTED

foo(
  # comment for foo
  foo: "foo",
)

#~# ORIGINAL multiple_comments_inside_method_call

foo(
# comment for foo
foo: "foo",

# comment for bar
bar: "bar",
)

#~# EXPECTED

foo(
  # comment for foo
  foo: "foo",

  # comment for bar
  bar: "bar",
)
