#~# ORIGINAL standalone (rightward assignment like syntax)

[0,1,2] => [a,*b]

#~# EXPECTED
[0, 1, 2] => [a, *b]

#~# ORIGINAL find pattern

case [0]
in [*x,
    0   => y  ,*z]
   1
   end

#~# EXPECTED
case [0]
in [*x, 0 => y, *z]
  1
end

#~# ORIGINAL find pattern unnamed rest args

case [0]
in [*,0,*]
   1
   end

#~# EXPECTED
case [0]
in [*, 0, *]
  1
end

#~# ORIGINAL find pattern multiple sub patterns

case [0,1,3]
in [*,0,1,Integer=>y,*a]
     y+(a[0]   ||  1  )
end

#~# EXPECTED
case [0, 1, 3]
in [*, 0, 1, Integer => y, *a]
  y + (a[0] || 1)
end

#~# ORIGINAL find constant pattern with parens

case   p
  in   Point(*,  1,*a)
     a
end

#~# EXPECTED
case p
in Point(*, 1, *a)
  a
end

#~# ORIGINAL find constant pattern with brackets

case   p
  in   Point[  * ,  1 ,  *a ]
     a
end

#~# EXPECTED
case p
in Point[*, 1, *a]
  a
end

#~# ORIGINAL issue_338

case
when true
end => { foo: }

#~# EXPECTED
case
when true
end => { foo: }

#~# ORIGINAL issue_338_2

case x
in true
end => { foo: }

#~# EXPECTED
case x
in true
end => { foo: }
