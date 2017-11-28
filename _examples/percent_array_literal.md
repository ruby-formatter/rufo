---
title: "percent\\_array\\_literal"
permalink: "/examples/percent_array_literal/"
toc: true
sidebar:
  nav: "examples"
---

### percent\_array\_literal 1
```ruby
# GIVEN
%w()
```
```ruby
# BECOMES
%w()
```
### percent\_array\_literal 2
```ruby
# GIVEN
%w(  )
```
```ruby
# BECOMES
%w()
```
### percent\_array\_literal 3
```ruby
# GIVEN
%w(one)
```
```ruby
# BECOMES
%w(one)
```
### percent\_array\_literal 4
```ruby
# GIVEN
%w( one )
```
```ruby
# BECOMES
%w( one )
```
### percent\_array\_literal 5
```ruby
# GIVEN
%w(one   two
 three )
```
```ruby
# BECOMES
%w(one two
   three)
```
### percent\_array\_literal 6
```ruby
# GIVEN
%w( one   two
 three )
```
```ruby
# BECOMES
%w( one two
    three )
```
### percent\_array\_literal 7
```ruby
# GIVEN
%w(
 one )
```
```ruby
# BECOMES
%w(
  one)
```
### percent\_array\_literal 8
```ruby
# GIVEN
%w(
 one
 )
```
```ruby
# BECOMES
%w(
  one
)
```
### percent\_array\_literal 9
```ruby
# GIVEN
%w[ one ]
```
```ruby
# BECOMES
%w[ one ]
```
### percent\_array\_literal 10
```ruby
# GIVEN
begin
 %w(
 one
 )
 end
```
```ruby
# BECOMES
begin
  %w(
    one
  )
end
```
### percent\_array\_literal 11
```ruby
# GIVEN
%i(  )
```
```ruby
# BECOMES
%i()
```
### percent\_array\_literal 12
```ruby
# GIVEN
%i( one )
```
```ruby
# BECOMES
%i( one )
```
### percent\_array\_literal 13
```ruby
# GIVEN
%i( one   two
 three )
```
```ruby
# BECOMES
%i( one two
    three )
```
### percent\_array\_literal 14
```ruby
# GIVEN
%i[ one ]
```
```ruby
# BECOMES
%i[ one ]
```
### percent\_array\_literal 15
```ruby
# GIVEN
%W( )
```
```ruby
# BECOMES
%W()
```
### percent\_array\_literal 16
```ruby
# GIVEN
%W( one )
```
```ruby
# BECOMES
%W( one )
```
### percent\_array\_literal 17
```ruby
# GIVEN
%W( one  two )
```
```ruby
# BECOMES
%W( one two )
```
### percent\_array\_literal 18
```ruby
# GIVEN
%W( one  two #{ 1 } )
```
```ruby
# BECOMES
%W( one two #{1} )
```
### percent\_array\_literal 19
```ruby
# GIVEN
%W(#{1}2)
```
```ruby
# BECOMES
%W(#{1}2)
```
### percent\_array\_literal 20
```ruby
# GIVEN
%I( )
```
```ruby
# BECOMES
%I()
```
### percent\_array\_literal 21
```ruby
# GIVEN
%I( one  two #{ 1 } )
```
```ruby
# BECOMES
%I( one two #{1} )
```
