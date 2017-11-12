---
title: "multiline\\_comments"
permalink: "/examples/multiline_comments/"
toc: true
sidebar:
  nav: "examples"
---

### multiline_comment
```ruby
# GIVEN
=begin
  foo
  bar
=end
```
```ruby
# BECOMES
=begin
  foo
  bar
=end
```
### multiline_comment_2
```ruby
# GIVEN
1

=begin
  foo
  bar
=end

2
```
```ruby
# BECOMES
1

=begin
  foo
  bar
=end

2
```
### multiline_comment_3
```ruby
# GIVEN
# foo
=begin
bar
=end
```
```ruby
# BECOMES
# foo
=begin
bar
=end
```
