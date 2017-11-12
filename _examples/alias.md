---
title: "alias"
permalink: "/examples/alias/"
toc: true
sidebar:
  nav: "examples"
---

### unnamed 2
```ruby
# GIVEN
alias  foo  bar
```
```ruby
# BECOMES
alias foo bar
```
### unnamed 3
```ruby
# GIVEN
alias  :foo  :bar
```
```ruby
# BECOMES
alias :foo :bar
```
### unnamed 4
```ruby
# GIVEN
alias  store  []=
```
```ruby
# BECOMES
alias store []=
```
### unnamed 5
```ruby
# GIVEN
alias  $foo  $bar
```
```ruby
# BECOMES
alias $foo $bar
```
