---
title: "string\\_literals"
permalink: "/examples/string_literals/"
toc: true
sidebar:
  nav: "examples"
---

### single_quote_string_literal
```ruby
# GIVEN
'hello'
```
```ruby
# BECOMES
'hello'
```
### double_quote_string_literal
```ruby
# GIVEN
"hello"
```
```ruby
# BECOMES
"hello"
```
### percent_q_string_literal
```ruby
# GIVEN
"hello"
```
```ruby
# BECOMES
"hello"
```
### percent_string_literal
```ruby
# GIVEN
"\n"
```
```ruby
# BECOMES
"\n"
```
### percent_string_literal_1
```ruby
# GIVEN
"hello #{1} foo"
```
```ruby
# BECOMES
"hello #{1} foo"
```
### percent_string_literal_2
```ruby
# GIVEN
"hello #{  1   } foo"
```
```ruby
# BECOMES
"hello #{1} foo"
```
### percent_string_literal_3
```ruby
# GIVEN
"hello #{
1} foo"
```
```ruby
# BECOMES
"hello #{1} foo"
```
### percent_string_literal_4
```ruby
# GIVEN
"#@foo"
```
```ruby
# BECOMES
"#@foo"
```
### percent_string_literal_5
```ruby
# GIVEN
"#@@foo"
```
```ruby
# BECOMES
"#@@foo"
```
### percent_string_literal_6
```ruby
# GIVEN
"#$foo"
```
```ruby
# BECOMES
"#$foo"
```
