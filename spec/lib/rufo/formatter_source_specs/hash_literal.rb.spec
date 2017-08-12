#~# ORIGINAL 

 { }

#~# EXPECTED

{}

#~# ORIGINAL 

 {:foo   =>   1 }

#~# EXPECTED

{ :foo => 1 }

#~# ORIGINAL 

 {:foo   =>   1}

#~# EXPECTED

{ :foo => 1 }

#~# ORIGINAL 

 { :foo   =>   1 }

#~# EXPECTED

{ :foo => 1 }

#~# ORIGINAL 

 { :foo   =>   1 , 2  =>  3  }

#~# EXPECTED

{ :foo => 1, 2 => 3 }

#~# ORIGINAL 

 { 
 :foo   =>   1 ,
 2  =>  3  }

#~# EXPECTED

{ :foo => 1, 2 => 3 }

#~# ORIGINAL large hash
#~# line_length: 10

{ :foo   =>   1 , 2  =>  3,
  :king => :panda, :bear => :honey }

#~# EXPECTED

{
  :foo => 1,
  2 => 3,
  :king => :panda,
  :bear => :honey,
}

#~# ORIGINAL 

 { **x }

#~# EXPECTED

{ **x }

#~# ORIGINAL 

 {foo:  1}

#~# EXPECTED

{ foo: 1 }

#~# ORIGINAL 

 { foo:  1 }

#~# EXPECTED

{ foo: 1 }

#~# ORIGINAL 

 { :foo   => 
  1 }

#~# EXPECTED

{ :foo  => 1 }

#~# ORIGINAL 

 { "foo": 1 } 

#~# EXPECTED

{ "foo": 1 }

#~# ORIGINAL 

 { "foo #{ 2 }": 1 } 

#~# EXPECTED

{ "foo #{2}": 1 }

#~# ORIGINAL 

 { :"one two"  => 3 } 

#~# EXPECTED

{ :"one two"  => 3 }

#~# ORIGINAL 

 { foo:  1, 
 bar: 2 }

#~# EXPECTED

{ foo: 1, bar: 2 }

#~# ORIGINAL 

{foo: 1,  bar: 2}

#~# EXPECTED

{ foo: 1, bar: 2 }

#~# ORIGINAL 

{1 =>
   2}

#~# EXPECTED

{1 =>  2}

#~# ORIGINAL skip hash that should break
#~# line_length: 10

{ a: :a, b: :b, c: :c, d: :d, e: :e, f: :f, g: :g }

#~# EXPECTED

{
  a: :a,
  b: :b,
  c: :c,
  d: :d,
  e: :e,
  f: :f,
  g: :g
}
