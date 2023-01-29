#~# ORIGINAL format_valueless_hash
{a:     }

#~# EXPECTED
{ a: }

#~# ORIGINAL format_mixed_hash
{a:  , b: 5   }

#~# EXPECTED
{ a:, b: 5 }

#~# ORIGINAL format_valueless_kwargs_method_call
foo(a:   )

#~# EXPECTED
foo(a:)

#~# ORIGINAL format_mixed_kwargs_method_call
foo(a:   , b: 5  )

#~# EXPECTED
foo(a:, b: 5)
