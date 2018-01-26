#~# ORIGINAL

{
 1 => 2,
 123 => 4 }

#~# EXPECTED

{
  1 => 2,
  123 => 4,
}

#~# ORIGINAL

{
 foo: 1,
 barbaz: 2 }

#~# EXPECTED

{
  foo: 1,
  barbaz: 2,
}

#~# ORIGINAL

foo bar: 1,
 barbaz: 2

#~# EXPECTED

foo bar: 1,
    barbaz: 2

#~# ORIGINAL

foo(
  bar: 1,
 barbaz: 2)

#~# EXPECTED

foo(
  bar: 1,
  barbaz: 2,
)

#~# ORIGINAL

def foo(x,
 y: 1,
 bar: 2)
end

#~# EXPECTED

def foo(x,
        y: 1,
        bar: 2)
end

#~# ORIGINAL

{1 => 2}
{123 => 4}

#~# EXPECTED

{1 => 2}
{123 => 4}

#~# ORIGINAL

{
 1 => 2,
 345 => {
  4 => 5
 }
 }

#~# EXPECTED

{
  1 => 2,
  345 => {
    4 => 5,
  },
}

#~# ORIGINAL

{
 1 => 2,
 345 => { # foo
  4 => 5
 }
 }

#~# EXPECTED

{
  1 => 2,
  345 => { # foo
    4 => 5,
  },
}

#~# ORIGINAL

{
 1 => 2,
 345 => [
  4
 ]
 }

#~# EXPECTED

{
  1 => 2,
  345 => [4],
}

#~# ORIGINAL

{
 1 => 2,
 foo: [
  4
 ]
 }

#~# EXPECTED

{
  1 => 2,
  foo: [4],
}

#~# ORIGINAL

foo 1, bar: [
         2,
       ],
       baz: 3

#~# EXPECTED

foo 1, bar: [2],
       baz: 3

#~# ORIGINAL

a   = b :foo => x,
  :baar => x

#~# EXPECTED

a = b :foo => x,
      :baar => x

#~# ORIGINAL

 {:foo   =>   1 }

#~# EXPECTED

{:foo => 1}

#~# ORIGINAL

 {:foo   =>   1}

#~# EXPECTED

{:foo => 1}

#~# ORIGINAL

 { :foo   =>   1 }

#~# EXPECTED

{:foo => 1}

#~# ORIGINAL

 { :foo   =>   1 , 2  =>  3  }

#~# EXPECTED

{:foo => 1, 2 => 3}

#~# ORIGINAL

 {
 :foo   =>   1 ,
 2  =>  3  }

#~# EXPECTED

{
  :foo => 1,
  2 => 3,
}

#~# ORIGINAL

 { foo:  1,
 bar: 2 }

#~# EXPECTED

{foo: 1,
 bar: 2}

#~# ORIGINAL

=begin
=end
{
  :a  => 1,
  :bc => 2
}

#~# EXPECTED

=begin
=end
{
  :a => 1,
  :bc => 2,
}

#~# ORIGINAL

foo 1,  :bar  =>  2 , :baz  =>  3

#~# EXPECTED

foo 1, :bar => 2, :baz => 3

#~# ORIGINAL

{
 foo: 1,
 barbaz: 2 }

#~# EXPECTED

{
  foo: 1,
  barbaz: 2,
}

