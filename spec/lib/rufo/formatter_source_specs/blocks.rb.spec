#~# ORIGINAL

foo   {}

#~# EXPECTED

foo { }

#~# ORIGINAL

foo   {   }

#~# EXPECTED

foo { }

#~# ORIGINAL

foo   {  1 }

#~# EXPECTED

foo { 1 }

#~# ORIGINAL

foo   {  1 ; 2 }

#~# EXPECTED

foo { 1; 2 }

#~# ORIGINAL

foo   {  1
 2 }

#~# EXPECTED

foo {
  1
  2
}

#~# ORIGINAL

foo {
  1 }

#~# EXPECTED

foo {
  1
}

#~# ORIGINAL

begin
 foo {  1  }
 end

#~# EXPECTED

begin
  foo { 1 }
end

#~# ORIGINAL

foo { | x , y | }

#~# EXPECTED

foo { |x, y| }

#~# ORIGINAL

foo { | x , | }

#~# EXPECTED

foo { |x, | }

#~# ORIGINAL

foo { | x , y, | bar}

#~# EXPECTED

foo { |x, y, | bar }

#~# ORIGINAL

foo { || }

#~# EXPECTED

foo { }

#~# ORIGINAL

foo { | | }

#~# EXPECTED

foo { }

#~# ORIGINAL

foo { | ( x ) , z | }

#~# EXPECTED

foo { |(x), z| }

#~# ORIGINAL

foo { | ( x , y ) , z | }

#~# EXPECTED

foo { |(x, y), z| }

#~# ORIGINAL

foo { | ( x , ( y , w ) ) , z | }

#~# EXPECTED

foo { |(x, (y, w)), z| }

#~# ORIGINAL

foo { | bar: 1 , baz: 2 | }

#~# EXPECTED

foo { |bar: 1, baz: 2| }

#~# ORIGINAL

foo { | *z | }

#~# EXPECTED

foo { |*z| }

#~# ORIGINAL

foo { | **z | }

#~# EXPECTED

foo { |**z| }

#~# ORIGINAL

foo { | bar = 1 | }

#~# EXPECTED

foo { |bar = 1| }

#~# ORIGINAL

foo { | x , y | 1 }

#~# EXPECTED

foo { |x, y| 1 }

#~# ORIGINAL

foo { | x |
  1 }

#~# EXPECTED

foo { |x|
  1
}

#~# ORIGINAL

foo { | x ,
 y |
  1 }

#~# EXPECTED

foo { |x,
       y|
  1
}

#~# ORIGINAL

foo   do   end

#~# EXPECTED

foo do end

#~# ORIGINAL

foo   do 1  end

#~# EXPECTED

foo do 1 end

#~# ORIGINAL

bar foo {
 1
 }, 2

#~# EXPECTED

bar foo {
  1
}, 2

#~# ORIGINAL

bar foo {
 1
 } + 2

#~# EXPECTED

bar foo {
  1
} + 2

#~# ORIGINAL

foo { |;x| }

#~# EXPECTED

foo { |; x| }

#~# ORIGINAL

foo { |
;x| }

#~# EXPECTED

foo { |; x| }

#~# ORIGINAL

foo { |;x, y| }

#~# EXPECTED

foo { |; x, y| }

#~# ORIGINAL

foo { |a, b;x, y| }

#~# EXPECTED

foo { |a, b; x, y| }

#~# ORIGINAL

proc { |(x, *y),z| }

#~# EXPECTED

proc { |(x, *y), z| }

#~# ORIGINAL

proc { |(w, *x, y), z| }

#~# EXPECTED

proc { |(w, *x, y), z| }

#~# ORIGINAL

foo { |(*x, y), z| }

#~# EXPECTED

foo { |(*x, y), z| }

#~# ORIGINAL

foo { begin; end; }

#~# EXPECTED

foo { begin; end }

#~# ORIGINAL

foo {
 |i| }

#~# EXPECTED

foo {
  |i| }
