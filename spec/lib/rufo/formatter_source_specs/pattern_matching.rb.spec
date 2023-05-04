#~# ORIGINAL literal value pattern

case   a
  in 1
   1
end

#~# EXPECTED
case a
in 1
  1
end

#~# ORIGINAL literal value pattern with else clause

case   a
  in 1
    1
   else
  2
end

#~# EXPECTED
case a
in 1
  1
else
  2
end

#~# ORIGINAL literal constant pattern

case Dry::Monads::Maybe(nil)
   in Dry::Monads::Some( x )
    puts x
 in Dry::Monads::None
   puts "2"
  end

#~# EXPECTED
case Dry::Monads::Maybe(nil)
in Dry::Monads::Some(x)
  puts x
in Dry::Monads::None
  puts "2"
end

#~# ORIGINAL nested in begin block

begin
 case   a
 in 1
 2
 in 3
 4
  else
 5
 end
 end

#~# EXPECTED
begin
  case a
  in 1
    2
  in 3
    4
  else
    5
  end
end

#~# ORIGINAL alternative pattern

case a
   in String |   [1, *  ]
    puts x
else
   puts "2"
  end

#~# EXPECTED
case a
in String | [1, *]
  puts x
else
  puts "2"
end

#~# ORIGINAL array pattern

case   [0]
  in [ a  ]
     a
end

#~# EXPECTED
case [0]
in [a]
  a
end

#~# ORIGINAL array pattern (empty)

case   [0]
  in []
     1
end

#~# EXPECTED
case [0]
in []
  1
end

#~# ORIGINAL array pattern (rest)

case [  0 ]
  in [ *a ]
     a
end

#~# EXPECTED
case [0]
in [*a]
  a
end

#~# ORIGINAL array pattern (pre rest and rest)

case [  0 ,1 ]
  in [ x  , *a ]
     a
end

#~# EXPECTED
case [0, 1]
in [x, *a]
  a
end

#~# ORIGINAL array pattern (rest and post rest)

case [  0 ,1 ]
  in [ *a, x  ]
     a
end

#~# EXPECTED
case [0, 1]
in [*a, x]
  a
end

#~# ORIGINAL array pattern (pre rest and rest and post rest)

case [  0 ,1 ]
  in [ y  ,*a, x  ]
     a
end

#~# EXPECTED
case [0, 1]
in [y, *a, x]
  a
end

#~# ORIGINAL array pattern (nested)
case   [ 0, [   1 ,  2 ,  3  ]
       ]
    in [      a , [   b    ,
              *c   ]  ]
    p   a #=> 0
   p  b #=> 1
  p      c #=> [2, 3]
end

#~# EXPECTED
case [0, [1, 2, 3]]
in [a, [b, *c]]
  p a #=> 0
  p b #=> 1
  p c #=> [2, 3]
end

#~# ORIGINAL array pattern (newline after bracket)
case [0]
    in [
      a  ,
    ]
    a
end

#~# EXPECTED
case [0]
in [
     a,
   ]
  a
end

#~# ORIGINAL array pattern (newline after comma)
case [0]
    in [  a,
     * ]
    a
end

#~# EXPECTED
case [0]
in [a, *]
  a
end

#~# ORIGINAL array pattern (without brackets)
case [1, 2, 3]
in   a ,   *rest
  "matched: #{a}, #{rest}"
else
  "not matched"
end

#~# EXPECTED
case [1, 2, 3]
in a, *rest
  "matched: #{a}, #{rest}"
else
  "not matched"
end

#~# ORIGINAL semicolon

case 1
 in a ; a
 end

#~# EXPECTED
case 1
in a; a
end

#~# ORIGINAL then keyword and else clause with semicolon

case 1
 in a then a + 2 else ;
 3
 end

#~# EXPECTED
case 1
in a then a + 2
else
  3
end

#~# ORIGINAL then keyword

case 1
 in a then a
 end

#~# EXPECTED
case 1
in a then a
end

#~# ORIGINAL array pattern with then keyword

case [0]
 in [a, b] then b
 in [a] then a
 end

#~# EXPECTED
case [0]
in [a, b] then b
in [a] then a
end

#~# ORIGINAL array pattern (rest) with then keyword

case [0]
 in [*a] then a else 3
 end

#~# EXPECTED
case [0]
in [*a] then a
else 3
end

#~# ORIGINAL

case [0]
in [
  *
]
   1
 end

#~# EXPECTED
case [0]
in [*]
  1
end

#~# ORIGINAL arary pattern and then keyword and else clause with semicolon

case [0]
 in [a,b] then a else ;
 3
 end

#~# EXPECTED
case [0]
in [a, b] then a
else
  3
end

#~# ORIGINAL semicolon and then keyword
case 4
in 2; then puts "2"
in 4; then puts "4"
end

#~# EXPECTED
case 4
in 2; then puts "2"
in 4; then puts "4"
end

#~# ORIGINAL standalone

[0,1,2] in [a,*b]

#~# EXPECTED
[0, 1, 2] in [a, *b]

#~# ORIGINAL guard clause (if)

case   [1,   2]
  in [ a, b]   if b==a*2
   a
end

#~# EXPECTED
case [1, 2]
in [a, b] if b == a * 2
  a
end

#~# ORIGINAL guard clause (unless)

case   [1,   2]
  in [ a, b]   unless b==a*2
   a
end

#~# EXPECTED
case [1, 2]
in [a, b] unless b == a * 2
  a
end

#~# ORIGINAL pin local variable

case   a
  in ^ b
   1
end

#~# EXPECTED
case a
in ^b
  1
end

#~# ORIGINAL pin local variable with rest

case   a
  in ^b,  *c
   1
end

#~# EXPECTED
case a
in ^b, *c
  1
end

#~# ORIGINAL array pattern without brackets

case   a
  in b  , c
   1
end

#~# EXPECTED
case a
in b, c
  1
end

#~# ORIGINAL

case   a
  in b  , *c
   1
end

#~# EXPECTED
case a
in b, *c
  1
end

#~# ORIGINAL

case   a
  in b  , *c,  d
   1
end

#~# EXPECTED
case a
in b, *c, d
  1
end

#~# ORIGINAL

case   a
  in *b  , c
   1
end

#~# EXPECTED
case a
in *b, c
  1
end

#~# ORIGINAL as pattern

case [1,2]
  in Integer  =>   a , Integer
   a+3
end

#~# EXPECTED
case [1, 2]
in Integer => a, Integer
  a + 3
end

#~# ORIGINAL array constant pattern with parens

case   p
  in   Point(  1,Integer =>a)
     a
end

#~# EXPECTED
case p
in Point(1, Integer => a)
  a
end

#~# ORIGINAL array constant pattern with brackets

case   p
  in  Point[1,Integer=>a   ]
a
end

#~# EXPECTED
case p
in Point[1, Integer => a]
  a
end

#~# ORIGINAL hash pattern

case   {a:1}
  in { a:  b }
     b
end

#~# EXPECTED
case { a: 1 }
in { a: b }
  b
end

#~# ORIGINAL hash pattern (multiple keys)

case   {a:1}
  in { a:  x,b:y }
     x +   y
end

#~# EXPECTED
case { a: 1 }
in { a: x, b: y }
  x + y
end

#~# ORIGINAL hash pattern (omit value)

case   {a:1}
  in { a:   }
     b
end

#~# EXPECTED
case { a: 1 }
in { a: }
  b
end

#~# ORIGINAL hash pattern (multiple keys omit value)

case   {a:1}
  in { a:  ,b: }
     a +  b
end

#~# EXPECTED
case { a: 1 }
in { a:, b: }
  a + b
end

#~# ORIGINAL hash pattern (empty)

case   {a:1}
  in {}
     1
end

#~# EXPECTED
case { a: 1 }
in {}
  1
end

#~# ORIGINAL hash pattern (rest with elements)

case {a:1}
  in {a:, **rest }
     rest
end

#~# EXPECTED
case { a: 1 }
in { a:, **rest }
  rest
end

#~# ORIGINAL hash pattern (anonymous rest with elements)

case {a:1}
  in {a:,**}
     a
end

#~# EXPECTED
case { a: 1 }
in { a:, ** }
  a
end

#~# ORIGINAL hash pattern (rest)

case {a:1}
  in { **rest}
     rest
end

#~# EXPECTED
case { a: 1 }
in { **rest }
  rest
end

#~# ORIGINAL hash pattern (anonymous rest)

case {a:1}
  in {**}
     1
end

#~# EXPECTED
case { a: 1 }
in { ** }
  1
end

#~# ORIGINAL hash pattern (nested)
case   {a: {b: 1, c: 2}}
in { a: { b:,
          **rest }  }
 p b # => 1
   p rest # => { c: 2 }
end

#~# EXPECTED
case { a: { b: 1, c: 2 } }
in { a: { b:, **rest } }
  p b # => 1
  p rest # => { c: 2 }
end

#~# ORIGINAL hash pattern (newline after bracket)
case h
    in {
      a:   ,
    }
    a
end

#~# EXPECTED
case h
in {
     a:,
   }
  a
end

#~# ORIGINAL hash pattern (newline after comma)
case h
    in {  a:,
     ** }
    a
end

#~# EXPECTED
case h
in { a:, ** }
  a
end

#~# ORIGINAL hash pattern (without braces)
case h
in   a: 1
    1
end

#~# EXPECTED
case h
in a: 1
  1
end

#~# ORIGINAL hash pattern (without braces and omit value)
case h
in   a: ,b:
  "matched: #{a}, #{b}"
else
  "not matched"
end

#~# EXPECTED
case h
in a:, b:
  "matched: #{a}, #{b}"
else
  "not matched"
end

#~# ORIGINAL hash pattern (without braces and with rest)
case h
in   a: ,b:,   **rest
  "matched: #{a}, #{b}, #{rest}"
else
  "not matched"
end

#~# EXPECTED
case h
in a:, b:, **rest
  "matched: #{a}, #{b}, #{rest}"
else
  "not matched"
end

#~# ORIGINAL
case {name: 'John', friends: [{name: 'Jane'}, {name: 'Rajesh'}]}
in name:, friends: [{name: first_friend}, *]
  "matched: #{first_friend}"
else
  "not matched"
end

#~# EXPECTED
case { name: "John", friends: [{ name: "Jane" }, { name: "Rajesh" }] }
in name:, friends: [{ name: first_friend }, *]
  "matched: #{first_friend}"
else
  "not matched"
end

#~# ORIGINAL
case {a:[1]}
in {a: [*]}
  1
else
   2
   end

#~# EXPECTED
case { a: [1] }
in { a: [*] }
  1
else
  2
end

#~# ORIGINAL hash constant pattern with parens
case Point.new(1, -2)
  in    SuperPoint(   x: 0.. =>px)
    "matched: #{px}"
else
  "not matched"
end

#~# EXPECTED
case Point.new(1, -2)
in SuperPoint(x: 0.. => px)
  "matched: #{px}"
else
  "not matched"
end

#~# ORIGINAL hash constant pattern with parens
case Point.new(1, -2)
  in    SuperPoint[x:0..=>px    ]
    "matched: #{px}"
else
  "not matched"
end

#~# EXPECTED
case Point.new(1, -2)
in SuperPoint[x: 0.. => px]
  "matched: #{px}"
else
  "not matched"
end

#~# ORIGINAL bug_304
rating in (9..10)

#~# EXPECTED
rating in (9..10)
