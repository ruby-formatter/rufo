#~# ORIGINAL skip
#~# align_hash_keys: true

{ 
 1 => 2, 
 123 => 4 }

#~# EXPECTED

{
  1   => 2,
  123 => 4
}

#~# ORIGINAL skip
#~# align_hash_keys: true

{ 
 foo: 1, 
 barbaz: 2 }

#~# EXPECTED

{
  foo:    1,
  barbaz: 2
}

#~# ORIGINAL skip
#~# align_hash_keys: true

foo bar: 1, 
 barbaz: 2

#~# EXPECTED

foo bar:    1,
    barbaz: 2

#~# ORIGINAL skip
#~# align_hash_keys: true

foo(
  bar: 1, 
 barbaz: 2)

#~# EXPECTED

foo(
  bar:    1,
  barbaz: 2
)

#~# ORIGINAL skip
#~# align_hash_keys: true

def foo(x, 
 y: 1, 
 bar: 2)
end

#~# EXPECTED

def foo(x,
        y:   1,
        bar: 2)
end

#~# ORIGINAL skip
#~# align_hash_keys: true

{1 => 2}
{123 => 4}

#~# EXPECTED

{1 => 2}
{123 => 4}

#~# ORIGINAL skip
#~# align_hash_keys: true

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
    4 => 5
  }
}

#~# ORIGINAL skip
#~# align_hash_keys: true

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
    4 => 5
  }
}

#~# ORIGINAL skip
#~# align_hash_keys: true

{
 1 => 2, 
 345 => [ 
  4 
 ] 
 }

#~# EXPECTED

{
  1 => 2,
  345 => [
    4
  ]
}

#~# ORIGINAL skip
#~# align_hash_keys: true

{
 1 => 2, 
 foo: [ 
  4 
 ] 
 }

#~# EXPECTED

{
  1 => 2,
  foo: [
    4
  ]
}

#~# ORIGINAL skip
#~# align_hash_keys: true

foo 1, bar: [
         2,
       ],
       baz: 3

#~# EXPECTED

foo 1, bar: [
         2,
       ],
       baz: 3

#~# ORIGINAL skip
#~# align_hash_keys: true

a   = b :foo => x,
  :baar => x

#~# EXPECTED

a   = b :foo  => x,
        :baar => x

#~# ORIGINAL skip
#~# align_hash_keys: true

 {:foo   =>   1 }

#~# EXPECTED

{:foo   => 1 }

#~# ORIGINAL skip
#~# align_hash_keys: true

 {:foo   =>   1}

#~# EXPECTED

{:foo   => 1}

#~# ORIGINAL skip
#~# align_hash_keys: true

 { :foo   =>   1 }

#~# EXPECTED

{ :foo   => 1 }

#~# ORIGINAL skip
#~# align_hash_keys: true

 { :foo   =>   1 , 2  =>  3  }

#~# EXPECTED

{ :foo   => 1, 2  => 3  }

#~# ORIGINAL skip
#~# align_hash_keys: true

 { 
 :foo   =>   1 ,
 2  =>  3  }

#~# EXPECTED

{
  :foo   => 1,
  2      => 3
}

#~# ORIGINAL skip
#~# align_hash_keys: true

 { foo:  1, 
 bar: 2 }

#~# EXPECTED

{ foo:  1,
  bar:  2 }

#~# ORIGINAL skip
#~# align_hash_keys: true

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
  :a  => 1,
  :bc => 2
}

#~# ORIGINAL skip
#~# align_hash_keys: true

foo 1,  :bar  =>  2 , :baz  =>  3

#~# EXPECTED

foo 1,  :bar  => 2, :baz  => 3

#~# ORIGINAL skip
#~# align_hash_keys: true

{ 
 foo: 1, 
 barbaz: 2 }

#~# EXPECTED

{
  foo:    1,
  barbaz: 2
}

