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

{
  :foo => 1,
  2 => 3,
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

{ :foo => 1 }

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

{ :"one two" => 3 }

#~# ORIGINAL

 { foo:  1,
   bar: 2 }

#~# EXPECTED

{ foo: 1,
  bar: 2 }

#~# ORIGINAL

{foo: 1,  bar: 2}

#~# EXPECTED

{ foo: 1, bar: 2 }

#~# ORIGINAL

{1 =>
   2}

#~# EXPECTED

{ 1 => 2 }

#~# ORIGINAL

{ 1 => {} }

#~# EXPECTED

{ 1 => {} }

#~# ORIGINAL

{1 => { }}

#~# EXPECTED

{ 1 => {} }

#~# ORIGINAL

{
1 => { }}

#~# EXPECTED

{
  1 => {},
}


#~# ORIGINAL

{ 1 => 2
}

#~# EXPECTED

{ 1 => 2 }
