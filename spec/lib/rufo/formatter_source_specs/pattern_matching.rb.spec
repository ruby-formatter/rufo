#~# ORIGINAL

case   a
  in 1
   1
end

#~# EXPECTED
case a
in 1
  1
end

#~# ORIGINAL

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

#~# ORIGINAL

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

#~# ORIGINAL

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

#~# ORIGINAL

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

#~# ORIGINAL

case   [0]
  in [ a  ]
     a
end

#~# EXPECTED
case [0]
in [a]
  a
end

#~# ORIGINAL

case   [0]
  in []
     1
end

#~# EXPECTED
case [0]
in []
  1
end

#~# ORIGINAL

case [  0 ]
  in [ *a ]
     a
end

#~# EXPECTED
case [0]
in [*a]
  a
end

#~# ORIGINAL

case [  0 ,1 ]
  in [ x  , *a ]
     a
end

#~# EXPECTED
case [0, 1]
in [x, *a]
  a
end

#~# ORIGINAL

case [  0 ,1 ]
  in [ *a, x  ]
     a
end

#~# EXPECTED
case [0, 1]
in [*a, x]
  a
end

#~# ORIGINAL

case [  0 ,1 ]
  in [ y  ,*a, x  ]
     a
end

#~# EXPECTED
case [0, 1]
in [y, *a, x]
  a
end

#~# ORIGINAL
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

#~# ORIGINAL
case [0]
    in [
      a  ,
    ]
    a
end

#~# EXPECTED
case [0]
in [a]
  a
end

#~# ORIGINAL
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

#~# ORIGINAL

case 1
 in a ; a
 end

#~# EXPECTED
case 1
in a; a
end

#~# ORIGINAL

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

#~# ORIGINAL

case 1
 in a then a
 end

#~# EXPECTED
case 1
in a then a
end

#~# ORIGINAL

case [0]
 in [a, b] then b
 in [a] then a
 end

#~# EXPECTED
case [0]
in [a, b] then b
in [a] then a
end

#~# ORIGINAL

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
 in a then a else ;
 3
 end

#~# EXPECTED
case [0]
in a then a
else
  3
end

#~# ORIGINAL
case 4
in 2; then puts "2"
in 4; then puts "4"
end

#~# EXPECTED
case 4
in 2; then puts "2"
in 4; then puts "4"
end

#~# ORIGINAL

[0,1,2] in [a,*b]

#~# EXPECTED
[0, 1, 2] in [a, *b]

#~# ORIGINAL

case   [1,   2]
  in [ a, b]   if b==a*2
   a
end

#~# EXPECTED
case [1, 2]
in [a, b] if b == a * 2
  a
end

#~# ORIGINAL

case   [1,   2]
  in [ a, b]   unless b==a*2
   a
end

#~# EXPECTED
case [1, 2]
in [a, b] unless b == a * 2
  a
end
