#~# ORIGINAL format_valueless_hash
{a:     }

#~# EXPECTED
{ a: }

#~# ORIGINAL format_mixed_hash
{a:  , b: 5   }

#~# EXPECTED
{ a:, b: 5 }

#~# ORIGINAL format_multiline_valueless_hash

 { foo:  ,
   bar: 2 }

#~# EXPECTED
{ foo:,
  bar: 2 }

#~# ORIGINAL format_valueless_kwargs_method_call
foo(a:   )

#~# EXPECTED
foo(a:)

#~# ORIGINAL format_mixed_kwargs_method_call
foo(a:   , b: 5  )

#~# EXPECTED
foo(a:, b: 5)

#~# ORIGINAL
foo(a: 1  , b:  )

#~# EXPECTED
foo(a: 1, b:)

#~# ORIGINAL
foo(  1, a:  )

#~# EXPECTED
foo(1, a:)

#~# ORIGINAL
foo( a:, )

#~# EXPECTED
foo(a:)

#~# ORIGINAL
foo(
a:,
  b:
)

#~# EXPECTED
foo(
  a:,
  b:,
)
