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
