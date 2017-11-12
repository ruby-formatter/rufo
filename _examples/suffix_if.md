---
title: "suffix\\_if"
permalink: "/examples/suffix_if/"
toc: true
sidebar:
  nav: "examples"
---

### unnamed 653
```ruby
# GIVEN
1 if 2
```
```ruby
# BECOMES
1 if 2
```
### unnamed 654
```ruby
# GIVEN
1 unless 2
```
```ruby
# BECOMES
1 unless 2
```
### unnamed 655
```ruby
# GIVEN
1 rescue 2
```
```ruby
# BECOMES
1 rescue 2
```
### unnamed 656
```ruby
# GIVEN
1 while 2
```
```ruby
# BECOMES
1 while 2
```
### unnamed 657
```ruby
# GIVEN
1 until 2
```
```ruby
# BECOMES
1 until 2
```
### unnamed 658
```ruby
# GIVEN
x.y rescue z
```
```ruby
# BECOMES
x.y rescue z
```
### unnamed 659
```ruby
# GIVEN
1  if  2
```
```ruby
# BECOMES
1 if 2
```
### unnamed 660
```ruby
# GIVEN
foo bar(1)  if  2
```
```ruby
# BECOMES
foo bar(1) if 2
```
