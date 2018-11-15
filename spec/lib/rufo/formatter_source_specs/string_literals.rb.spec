#~# ORIGINAL single_quote_string_literal

'hello'

#~# EXPECTED

"hello"

#~# ORIGINAL double_quote_string_literal

"hello"

#~# EXPECTED

"hello"

#~# ORIGINAL percent_q_string_literal

"hello"

#~# EXPECTED

"hello"

#~# ORIGINAL percent_string_literal

"\n"

#~# EXPECTED

"\n"

#~# ORIGINAL percent_string_literal_1

"hello #{1} foo"

#~# EXPECTED

"hello #{1} foo"

#~# ORIGINAL single_quote_percent_string_literal_1

'hello #{1} foo'

#~# EXPECTED

"hello \#{1} foo"

#~# ORIGINAL single_quote_percent_string_literal_2

'hello \#{1} foo'

#~# EXPECTED

'hello \#{1} foo'

#~# ORIGINAL single_quote_percent_string_literal_3

'hello \ #{1} foo'

#~# EXPECTED

'hello \ #{1} foo'

#~# ORIGINAL single_quote_percent_string_literal_4

'hello #{
1} foo'

#~# EXPECTED

"hello \#{
1} foo"

#~# ORIGINAL single_quote_percent_string_literal_5

'hello #@foo foo'

#~# EXPECTED

"hello \#@foo foo"

#~# ORIGINAL single_quote_percent_string_literal_6

'hello \ #@foo foo'

#~# EXPECTED

'hello \ #@foo foo'

#~# ORIGINAL single_quote_percent_string_literal_7

'hello #$foo foo'

#~# EXPECTED

"hello \#$foo foo"

#~# ORIGINAL single_quote_percent_string_literal_8

'hello \ #$foo foo'

#~# EXPECTED

'hello \ #$foo foo'

#~# ORIGINAL percent_string_literal_2

"hello #{  1   } foo"

#~# EXPECTED

"hello #{1} foo"

#~# ORIGINAL percent_string_literal_3

"hello #{
1} foo"

#~# EXPECTED

"hello #{1} foo"

#~# ORIGINAL percent_string_literal_4

"#@foo"

#~# EXPECTED

"#@foo"

#~# ORIGINAL percent_string_literal_5

"#@@foo"

#~# EXPECTED

"#@@foo"

#~# ORIGINAL percent_string_literal_6

"#$foo"

#~# EXPECTED

"#$foo"
