#~# ORIGINAL 

Foo

#~# EXPECTED

Foo

#~# ORIGINAL 

Foo::Bar::Baz

#~# EXPECTED

Foo::Bar::Baz

#~# ORIGINAL 

Foo::Bar::Baz

#~# EXPECTED

Foo::Bar::Baz

#~# ORIGINAL 

Foo:: Bar:: Baz

#~# EXPECTED

Foo::Bar::Baz

#~# ORIGINAL 

Foo:: 
Bar

#~# EXPECTED

Foo::Bar

#~# ORIGINAL 

::Foo

#~# EXPECTED

::Foo

#~# ORIGINAL 

::Foo::Bar

#~# EXPECTED

::Foo::Bar

#~# ORIGINAL 

::Foo = 1

#~# EXPECTED

::Foo = 1

#~# ORIGINAL 

::Foo::Bar = 1

#~# EXPECTED

::Foo::Bar = 1
