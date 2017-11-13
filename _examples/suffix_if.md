---
title: "suffix\\_if"
permalink: "/examples/suffix_if/"
toc: true
sidebar:
  nav: "examples"
---

### suffix\_if 1
```ruby
# GIVEN
1 if 2
```
```ruby
# BECOMES
1 if 2
```
### suffix\_if 2
```ruby
# GIVEN
1 unless 2
```
```ruby
# BECOMES
1 unless 2
```
### suffix\_if 3
```ruby
# GIVEN
1 rescue 2
```
```ruby
# BECOMES
1 rescue 2
```
### suffix\_if 4
```ruby
# GIVEN
1 while 2
```
```ruby
# BECOMES
1 while 2
```
### suffix\_if 5
```ruby
# GIVEN
1 until 2
```
```ruby
# BECOMES
1 until 2
```
### suffix\_if 6
```ruby
# GIVEN
x.y rescue z
```
```ruby
# BECOMES
x.y rescue z
```
### suffix\_if 7
```ruby
# GIVEN
1  if  2
```
```ruby
# BECOMES
1 if 2
```
### suffix\_if 8
```ruby
# GIVEN
foo bar(1)  if  2
```
```ruby
# BECOMES
foo bar(1) if 2
```
