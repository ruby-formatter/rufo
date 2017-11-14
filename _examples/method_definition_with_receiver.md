---
title: "method\\_definition\\_with\\_receiver"
permalink: "/examples/method_definition_with_receiver/"
toc: true
sidebar:
  nav: "examples"
---

### method\_definition\_with\_receiver 1
```ruby
# GIVEN
def foo .
 bar; end
```
```ruby
# BECOMES
def foo.bar; end
```
### method\_definition\_with\_receiver 2
```ruby
# GIVEN
def self .
 bar; end
```
```ruby
# BECOMES
def self.bar; end
```
### multi_inline_definitions
```ruby
# GIVEN
def foo(x); end; def bar(y); end
```
```ruby
# BECOMES
def foo(x); end
def bar(y); end
```
### multi_inline_definitions_2
```ruby
# GIVEN
def foo(x); x end; def bar(y); y end
```
```ruby
# BECOMES
def foo(x); x end
def bar(y); y end
```
### multi_inline_definitions_with_comment
```ruby
# GIVEN
def a x;x end;def b y;y end;def c z;z end # comment
```
```ruby
# BECOMES
def a(x); x end
def b(y); y end
def c(z); z end # comment
```
```ruby
# with setting `parens_in_def :dynamic`
def a x; x end
def b y; y end
def c z; z end # comment
```
