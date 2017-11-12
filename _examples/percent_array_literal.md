---
title: "percent\\_array\\_literal"
permalink: "/examples/percent_array_literal/"
toc: true
sidebar:
  nav: "examples"
---

### unnamed 530
```ruby
# GIVEN
%w(  )
```
```ruby
# BECOMES
%w()
```
### unnamed 531
```ruby
# GIVEN
%w(one)
```
```ruby
# BECOMES
%w(one)
```
### unnamed 532
```ruby
# GIVEN
%w( one )
```
```ruby
# BECOMES
%w( one )
```
### unnamed 533
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
### unnamed 534
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
### unnamed 535
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
### unnamed 536
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
### unnamed 537
```ruby
# GIVEN
%w[ one ]
```
```ruby
# BECOMES
%w[ one ]
```
### unnamed 538
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
### unnamed 539
```ruby
# GIVEN
%i(  )
```
```ruby
# BECOMES
%i()
```
### unnamed 540
```ruby
# GIVEN
%i( one )
```
```ruby
# BECOMES
%i( one )
```
### unnamed 541
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
### unnamed 542
```ruby
# GIVEN
%i[ one ]
```
```ruby
# BECOMES
%i[ one ]
```
### unnamed 543
```ruby
# GIVEN
%W( )
```
```ruby
# BECOMES
%W()
```
### unnamed 544
```ruby
# GIVEN
%W( one )
```
```ruby
# BECOMES
%W( one )
```
### unnamed 545
```ruby
# GIVEN
%W( one  two )
```
```ruby
# BECOMES
%W( one two )
```
### unnamed 546
```ruby
# GIVEN
%W( one  two #{ 1 } )
```
```ruby
# BECOMES
%W( one two #{1} )
```
### unnamed 547
```ruby
# GIVEN
%W(#{1}2)
```
```ruby
# BECOMES
%W(#{1}2)
```
### unnamed 548
```ruby
# GIVEN
%I( )
```
```ruby
# BECOMES
%I()
```
### unnamed 549
```ruby
# GIVEN
%I( one  two #{ 1 } )
```
```ruby
# BECOMES
%I( one two #{1} )
```
