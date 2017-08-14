#~# ORIGINAL string literal

'hello'

#~# EXPECTED

'hello'

#~# ORIGINAL string with useless prefix spaces

     'hello'

#~# EXPECTED

'hello'

#~# ORIGINAL two strings

"hello"
"hello"

#~# EXPECTED

"hello"
"hello"

#~# ORIGINAL two strings with a newline between

"hello"

"hello"

#~# EXPECTED

"hello"

"hello"

#~# ORIGINAL string interpolation

"hello #{name}"

#~# EXPECTED

"hello #{name}"

#~# ORIGINAL string interpolation with useless spaces before

"hello #{  name}"

#~# EXPECTED

"hello #{name}"

#~# ORIGINAL string interpolation with useless spaces after

"hello #{name   }"

#~# EXPECTED

"hello #{name}"

#~# ORIGINAL string interpolation with useless spaces around

"hello #{  name   }"

#~# EXPECTED

"hello #{name}"

#~# ORIGINAL string interpolation with useless newlines around

"hello #{
name}"

#~# EXPECTED

"hello #{name}"

#~# ORIGINAL two string statements

'hello';"hello"

#~# EXPECTED

'hello'
"hello"

#~# ORIGINAL max one line separates expressions

'hello'


'hello'

#~# EXPECTED

'hello'

'hello'
