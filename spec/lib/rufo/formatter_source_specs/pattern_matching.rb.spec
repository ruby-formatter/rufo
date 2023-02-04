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
