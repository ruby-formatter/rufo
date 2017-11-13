---
title: "align\\_mix"
permalink: "/examples/align_mix/"
toc: true
sidebar:
  nav: "examples"
---

### align\_mix 1
```ruby
# GIVEN
abc = 1
a = {foo: 1, # comment
 bar: 2} # another
```
```ruby
# BECOMES
abc = 1
a = {foo: 1, # comment
     bar: 2} # another
```
### align\_mix 2
```ruby
# GIVEN
abc = 1
a = {foobar: 1, # comment
 bar: 2} # another
```
```ruby
# BECOMES
abc = 1
a = {foobar: 1, # comment
     bar: 2} # another
```
