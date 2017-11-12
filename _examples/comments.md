---
title: "comments"
permalink: "/examples/comments/"
toc: true
sidebar:
  nav: "examples"
---

### comment
```ruby
# GIVEN
# foo
```
```ruby
# BECOMES
# foo
```
### two_comments
```ruby
# GIVEN
# foo
# bar
```
```ruby
# BECOMES
# foo
# bar
```
### integer_with_comment
```ruby
# GIVEN
1   # foo
```
```ruby
# BECOMES
1   # foo
```
### comment_with_double_line_break
```ruby
# GIVEN
# a

# b
```
```ruby
# BECOMES
# a

# b
```
### comment_with_triple_line_break
```ruby
# GIVEN
# a


# b
```
```ruby
# BECOMES
# a

# b
```
### comment_and_integer
```ruby
# GIVEN
# a
1
```
```ruby
# BECOMES
# a
1
```
### comment_double_newline_integer
```ruby
# GIVEN
# a


1
```
```ruby
# BECOMES
# a

1
```
### integer_with_comment_and_following_comment
```ruby
# GIVEN
1 # a
# b
```
```ruby
# BECOMES
1 # a
# b
```
### integer_with_comment_and_multiline_break
```ruby
# GIVEN
1 # a

# b
```
```ruby
# BECOMES
1 # a

# b
```
### integers_separated_by_comments
```ruby
# GIVEN
1 # a

2 # b
```
```ruby
# BECOMES
1 # a

2 # b
```
### multiple_trailing_comments
```ruby
# GIVEN
1 # a


2 # b
```
```ruby
# BECOMES
1 # a

2 # b
```
### more_trailing_comments
```ruby
# GIVEN
1 # a






2 # b
```
```ruby
# BECOMES
1 # a

2 # b
```
### still_more_trailing_comments
```ruby
# GIVEN
1 # a


# b


 # c
 2 # b
```
```ruby
# BECOMES
1 # a

# b

# c
2 # b
```
### comment_indentation_inside_method_call
```ruby
# GIVEN
foo(
# comment for foo
foo: 'foo'
)
```
```ruby
# BECOMES
foo(
  # comment for foo
  foo: 'foo',
)
```
```ruby
# with setting `trailing_commas false`
foo(
  # comment for foo
  foo: 'foo'
)
```
### comment_indentation_inside_method_call_2
```ruby
# GIVEN
foo(
 # comment for foo
foo: 'foo'
)
```
```ruby
# BECOMES
foo(
  # comment for foo
  foo: 'foo',
)
```
```ruby
# with setting `trailing_commas false`
foo(
  # comment for foo
  foo: 'foo'
)
```
### comment_indentation_inside_method_call_3
```ruby
# GIVEN
foo(
  # comment for foo
foo: 'foo'
)
```
```ruby
# BECOMES
foo(
  # comment for foo
  foo: 'foo',
)
```
```ruby
# with setting `trailing_commas false`
foo(
  # comment for foo
  foo: 'foo'
)
```
### comment_indentation_inside_method_call_4
```ruby
# GIVEN
foo(
   # comment for foo
foo: 'foo'
)
```
```ruby
# BECOMES
foo(
  # comment for foo
  foo: 'foo',
)
```
```ruby
# with setting `trailing_commas false`
foo(
  # comment for foo
  foo: 'foo'
)
```
### multiple_comments_inside_method_call
```ruby
# GIVEN
foo(
# comment for foo
foo: 'foo',

# comment for bar
bar: 'bar',
)
```
```ruby
# BECOMES
foo(
  # comment for foo
  foo: 'foo',

  # comment for bar
  bar: 'bar',
)
```
```ruby
# with setting `trailing_commas false`
foo(
  # comment for foo
  foo: 'foo',

  # comment for bar
  bar: 'bar'
)
```
