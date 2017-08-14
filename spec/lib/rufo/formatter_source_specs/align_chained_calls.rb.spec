#~# ORIGINAL skip
#~# align_chained_calls: true

foo . bar 
 . baz

#~# EXPECTED

foo . bar
    . baz

#~# ORIGINAL skip
#~# align_chained_calls: true

foo . bar 
 . baz 
 . qux

#~# EXPECTED

foo . bar
    . baz
    . qux

#~# ORIGINAL skip
#~# align_chained_calls: true

foo . bar( x.y ) 
 . baz 
 . qux

#~# EXPECTED

foo . bar(x.y)
    . baz
    . qux

#~# ORIGINAL skip

x.foo
 .bar { a.b }
 .baz

#~# EXPECTED

x.foo
 .bar { a.b }
 .baz

