#~# ORIGINAL
#~# quote_style: :mixed

'a great string'
"a great string"

#~# EXPECTED
'a great string'
"a great string"

#~# ORIGINAL
#~# quote_style: :mixed

'🚀'
"🚀"

#~# EXPECTED
'🚀'
"🚀"

#~# ORIGINAL
#~# quote_style: :mixed

''
""

#~# EXPECTED
''
""

#~# ORIGINAL
#~# quote_style: :mixed

'import \"quotes\"'

#~# EXPECTED
'import \"quotes\"'

#~# ORIGINAL
#~# quote_style: :mixed

"#{interpolation}"

#~# EXPECTED
"#{interpolation}"

#~# ORIGINAL
#~# quote_style: :mixed

"\0 \x7e \e \n \r \t \u1f680 \'"

#~# EXPECTED
"\0 \x7e \e \n \r \t \u1f680 \'"

#~# ORIGINAL
#~# quote_style: :mixed

%q(single)

#~# EXPECTED
%q(single)

#~# ORIGINAL
#~# quote_style: :mixed

%Q(double)

#~# EXPECTED
%Q(double)
