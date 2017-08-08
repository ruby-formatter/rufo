#~# ORIGINAL 

begin 
 1 
 rescue 
 2 
 end

#~# EXPECTED

begin
  1
rescue
  2
end

#~# ORIGINAL 

begin
rescue A
rescue B
end

#~# EXPECTED

begin
rescue A
rescue B
end

#~# ORIGINAL 

begin 
 1 
 rescue   Foo 
 2 
 end

#~# EXPECTED

begin
  1
rescue Foo
  2
end

#~# ORIGINAL 

begin 
 1 
 rescue  =>   ex  
 2 
 end

#~# EXPECTED

begin
  1
rescue => ex
  2
end

#~# ORIGINAL 

begin 
 1 
 rescue  Foo  =>  ex 
 2 
 end

#~# EXPECTED

begin
  1
rescue Foo => ex
  2
end

#~# ORIGINAL 

begin 
 1 
 rescue  Foo  , Bar , Baz =>  ex 
 2 
 end

#~# EXPECTED

begin
  1
rescue Foo, Bar, Baz => ex
  2
end

#~# ORIGINAL 

begin 
 1 
 rescue  Foo  , 
 Bar , 
 Baz =>  ex 
 2 
 end

#~# EXPECTED

begin
  1
rescue Foo,
       Bar,
       Baz => ex
  2
end

#~# ORIGINAL 

begin 
 1 
 ensure 
 2 
 end

#~# EXPECTED

begin
  1
ensure
  2
end

#~# ORIGINAL 

begin 
 1 
 else 
 2 
 end

#~# EXPECTED

begin
  1
else
  2
end

#~# ORIGINAL 

begin
  1
rescue *x
end

#~# EXPECTED

begin
  1
rescue *x
end

#~# ORIGINAL 

begin
  1
rescue *x, *y
end

#~# EXPECTED

begin
  1
rescue *x, *y
end

#~# ORIGINAL 

begin
  1
rescue *x, y, *z
end

#~# EXPECTED

begin
  1
rescue *x, y, *z
end
