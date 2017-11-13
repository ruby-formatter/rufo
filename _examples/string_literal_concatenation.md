---
title: "string\\_literal\\_concatenation"
permalink: "/examples/string_literal_concatenation/"
toc: true
sidebar:
  nav: "examples"
---

### string\_literal\_concatenation 1
```ruby
# GIVEN
"foo"   "bar"
```
```ruby
# BECOMES
"foo" "bar"
```
### string\_literal\_concatenation 2
```ruby
# GIVEN
"foo" \
 "bar"
```
```ruby
# BECOMES
"foo" \
"bar"
```
### string\_literal\_concatenation 3
```ruby
# GIVEN
x 1, "foo" \
     "bar"
```
```ruby
# BECOMES
x 1, "foo" \
     "bar"
```
