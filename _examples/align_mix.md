---
title: "align\\_mix"
permalink: "/examples/align_mix/"
toc: true
sidebar:
  nav: "examples"
---

### unnamed 73
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
### unnamed 74
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
