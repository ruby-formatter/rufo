#~# ORIGINAL

%w()

#~# EXPECTED

%w()

#~# ORIGINAL

 %w(  )

#~# EXPECTED

%w()

#~# ORIGINAL

 %w(one)

#~# EXPECTED

%w(one)

#~# ORIGINAL

 %w( one )

#~# EXPECTED

%w( one )

#~# ORIGINAL

 %w(one   two
 three )

#~# EXPECTED

%w(one two
   three)

#~# ORIGINAL

 %w( one   two
 three )

#~# EXPECTED

%w( one two
    three )

#~# ORIGINAL

 %w(
 one )

#~# EXPECTED

%w(
  one)

#~# ORIGINAL

 %w(
 one
 )

#~# EXPECTED

%w(
  one
)

#~# ORIGINAL

 %w[ one ]

#~# EXPECTED

%w[ one ]

#~# ORIGINAL

 begin
 %w(
 one
 )
 end

#~# EXPECTED

begin
  %w(
    one
  )
end

#~# ORIGINAL

 %i(  )

#~# EXPECTED

%i()

#~# ORIGINAL

 %i( one )

#~# EXPECTED

%i( one )

#~# ORIGINAL

 %i( one   two
 three )

#~# EXPECTED

%i( one two
    three )

#~# ORIGINAL

 %i[ one ]

#~# EXPECTED

%i[ one ]

#~# ORIGINAL

 %W( )

#~# EXPECTED

%W()

#~# ORIGINAL

 %W( one )

#~# EXPECTED

%W( one )

#~# ORIGINAL

 %W( one  two )

#~# EXPECTED

%W( one two )

#~# ORIGINAL

 %W( one  two #{ 1 } )

#~# EXPECTED

%W( one two #{1} )

#~# ORIGINAL

%W(#{1}2)

#~# EXPECTED

%W(#{1}2)

#~# ORIGINAL

 %I( )

#~# EXPECTED

%I()

#~# ORIGINAL

 %I( one  two #{ 1 } )

#~# EXPECTED

%I( one two #{1} )
