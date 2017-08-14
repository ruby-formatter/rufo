#~# ORIGINAL 

alias  foo  bar

#~# EXPECTED

alias foo bar

#~# ORIGINAL 

alias  :foo  :bar

#~# EXPECTED

alias :foo :bar

#~# ORIGINAL 

alias  store  []=

#~# EXPECTED

alias store []=

#~# ORIGINAL 

alias  $foo  $bar

#~# EXPECTED

alias $foo $bar
