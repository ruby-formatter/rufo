---
title: "blocks"
permalink: "/examples/blocks/"
toc: true
sidebar:
  nav: "examples"
---

### unnamed 183
```ruby
# GIVEN
foo   {}
```
```ruby
# BECOMES
foo { }
```
### unnamed 184
```ruby
# GIVEN
foo   {   }
```
```ruby
# BECOMES
foo { }
```
### unnamed 185
```ruby
# GIVEN
foo   {  1 }
```
```ruby
# BECOMES
foo { 1 }
```
### unnamed 186
```ruby
# GIVEN
foo   {  1 ; 2 }
```
```ruby
# BECOMES
foo { 1; 2 }
```
### unnamed 187
```ruby
# GIVEN
foo   {  1
 2 }
```
```ruby
# BECOMES
foo {
  1
  2
}
```
### unnamed 188
```ruby
# GIVEN
foo {
  1 }
```
```ruby
# BECOMES
foo {
  1
}
```
### unnamed 189
```ruby
# GIVEN
begin
 foo {  1  }
 end
```
```ruby
# BECOMES
begin
  foo { 1 }
end
```
### unnamed 190
```ruby
# GIVEN
foo { | x , y | }
```
```ruby
# BECOMES
foo { |x, y| }
```
### unnamed 191
```ruby
# GIVEN
foo { | x , | }
```
```ruby
# BECOMES
foo { |x, | }
```
### unnamed 192
```ruby
# GIVEN
foo { | x , y, | bar}
```
```ruby
# BECOMES
foo { |x, y, | bar }
```
### unnamed 193
```ruby
# GIVEN
foo { || }
```
```ruby
# BECOMES
foo { }
```
### unnamed 194
```ruby
# GIVEN
foo { | | }
```
```ruby
# BECOMES
foo { }
```
### unnamed 195
```ruby
# GIVEN
foo { | ( x ) , z | }
```
```ruby
# BECOMES
foo { |(x), z| }
```
### unnamed 196
```ruby
# GIVEN
foo { | ( x , y ) , z | }
```
```ruby
# BECOMES
foo { |(x, y), z| }
```
### unnamed 197
```ruby
# GIVEN
foo { | ( x , ( y , w ) ) , z | }
```
```ruby
# BECOMES
foo { |(x, (y, w)), z| }
```
### unnamed 198
```ruby
# GIVEN
foo { | bar: 1 , baz: 2 | }
```
```ruby
# BECOMES
foo { |bar: 1, baz: 2| }
```
### unnamed 199
```ruby
# GIVEN
foo { | *z | }
```
```ruby
# BECOMES
foo { |*z| }
```
### unnamed 200
```ruby
# GIVEN
foo { | **z | }
```
```ruby
# BECOMES
foo { |**z| }
```
### unnamed 201
```ruby
# GIVEN
foo { | bar = 1 | }
```
```ruby
# BECOMES
foo { |bar = 1| }
```
### unnamed 202
```ruby
# GIVEN
foo { | x , y | 1 }
```
```ruby
# BECOMES
foo { |x, y| 1 }
```
### unnamed 203
```ruby
# GIVEN
foo { | x |
  1 }
```
```ruby
# BECOMES
foo { |x|
  1
}
```
### unnamed 204
```ruby
# GIVEN
foo { | x ,
 y |
  1 }
```
```ruby
# BECOMES
foo { |x,
       y|
  1
}
```
### unnamed 205
```ruby
# GIVEN
foo   do   end
```
```ruby
# BECOMES
foo do end
```
### unnamed 206
```ruby
# GIVEN
foo   do 1  end
```
```ruby
# BECOMES
foo do 1 end
```
### unnamed 207
```ruby
# GIVEN
bar foo {
 1
 }, 2
```
```ruby
# BECOMES
bar foo {
  1
}, 2
```
### unnamed 208
```ruby
# GIVEN
bar foo {
 1
 } + 2
```
```ruby
# BECOMES
bar foo {
  1
} + 2
```
### unnamed 209
```ruby
# GIVEN
foo { |;x| }
```
```ruby
# BECOMES
foo { |; x| }
```
### unnamed 210
```ruby
# GIVEN
foo { |
;x| }
```
```ruby
# BECOMES
foo { |; x| }
```
### unnamed 211
```ruby
# GIVEN
foo { |;x, y| }
```
```ruby
# BECOMES
foo { |; x, y| }
```
### unnamed 212
```ruby
# GIVEN
foo { |a, b;x, y| }
```
```ruby
# BECOMES
foo { |a, b; x, y| }
```
### unnamed 213
```ruby
# GIVEN
proc { |(x, *y),z| }
```
```ruby
# BECOMES
proc { |(x, *y), z| }
```
### unnamed 214
```ruby
# GIVEN
proc { |(w, *x, y), z| }
```
```ruby
# BECOMES
proc { |(w, *x, y), z| }
```
### unnamed 215
```ruby
# GIVEN
foo { |(*x, y), z| }
```
```ruby
# BECOMES
foo { |(*x, y), z| }
```
### unnamed 216
```ruby
# GIVEN
foo { begin; end; }
```
```ruby
# BECOMES
foo { begin; end }
```
### unnamed 217
```ruby
# GIVEN
foo {
 |i| }
```
```ruby
# BECOMES
foo {
  |i| }
```
