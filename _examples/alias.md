---
title: "alias"
permalink: "/examples/alias/"
toc: true
sidebar:
  nav: "examples"
---

### alias 1
```ruby
# GIVEN
alias  foo  bar
```
```ruby
# BECOMES
alias foo bar
```
### alias 2
```ruby
# GIVEN
alias  :foo  :bar
```
```ruby
# BECOMES
alias :foo :bar
```
### alias 3
```ruby
# GIVEN
alias  store  []=
```
```ruby
# BECOMES
alias store []=
```
### alias 4
```ruby
# GIVEN
alias  $foo  $bar
```
```ruby
# BECOMES
alias $foo $bar
```
