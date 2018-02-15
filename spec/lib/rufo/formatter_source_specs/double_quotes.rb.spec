#~# ORIGINAL
#~# quote_style: :double

'a great string'

#~# EXPECTED

"a great string"

#~# ORIGINAL
#~# quote_style: :double

'🚀'

#~# EXPECTED

"🚀"

#~# ORIGINAL
#~# quote_style: :double

''

#~# EXPECTED

""

#~# ORIGINAL
#~# quote_style: :double

'import \"quotes\"'

#~# EXPECTED

'import \"quotes\"'

#~# ORIGINAL
#~# quote_style: :double

"#{interpolation}"

#~# EXPECTED

"#{interpolation}"

#~# ORIGINAL
#~# quote_style: :double

"\0 \x7e \e \n \r \t \u1f680 \'"

#~# EXPECTED

"\0 \x7e \e \n \r \t \u1f680 \'"

#~# ORIGINAL
#~# quote_style: :double

%q(single)

#~# EXPECTED

%q(single)

#~# ORIGINAL
#~# quote_style: :double

%Q(double)

#~# EXPECTED

%Q(double)
