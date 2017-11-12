---
title: "string\\_literal\\_concatenation"
permalink: "/examples/string_literal_concatenation/"
toc: true
sidebar:
  nav: "examples"
---

### unnamed 640
```ruby
# GIVEN
"foo"   "bar"
```
```ruby
# BECOMES
"foo" "bar"
```
### unnamed 641
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
### unnamed 642
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
