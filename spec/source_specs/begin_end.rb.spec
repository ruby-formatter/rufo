#~# ORIGINAL 

begin;end

#~# EXPECTED

begin; end

#~# ORIGINAL 

begin 
 end

#~# EXPECTED

begin
end

#~# ORIGINAL 

begin 1 end

#~# EXPECTED

begin 1 end

#~# ORIGINAL 

begin; 1; end

#~# EXPECTED

begin; 1; end

#~# ORIGINAL 

begin; 1; 2; end

#~# EXPECTED

begin; 1; 2; end

#~# ORIGINAL 

begin; 1 
 2; end

#~# EXPECTED

begin; 1
  2; end

#~# ORIGINAL 

begin
 1 
 end

#~# EXPECTED

begin
  1
end

#~# ORIGINAL 

begin
 1 
 2 
 end

#~# EXPECTED

begin
  1
  2
end

#~# ORIGINAL 

begin 
 begin 
 1 
 end 
 2 
 end

#~# EXPECTED

begin
  begin
    1
  end
  2
end

#~# ORIGINAL 

begin # hello
 end

#~# EXPECTED

begin # hello
end

#~# ORIGINAL 

begin;# hello
 end

#~# EXPECTED

begin # hello
end

#~# ORIGINAL 

begin
 1  # a
end

#~# EXPECTED

begin
  1  # a
end

#~# ORIGINAL 

begin
 1  # a
 # b 
 3 # c 
 end

#~# EXPECTED

begin
  1  # a
  # b
  3 # c
end

#~# ORIGINAL 

begin
end

# foo

#~# EXPECTED

begin
end

# foo

#~# ORIGINAL 

begin
  begin 1 end
end

#~# EXPECTED

begin
  begin 1 end
end

#~# ORIGINAL 

begin
  def foo(x) 1 end
end

#~# EXPECTED

begin
  def foo(x) 1 end
end

#~# ORIGINAL 

begin
  if 1 then 2 end
end

#~# EXPECTED

begin
  if 1 then 2 end
end

#~# ORIGINAL 

begin
  if 1 then 2 end
end

#~# EXPECTED

begin
  if 1 then 2 end
end

#~# ORIGINAL 

begin
  foo do 1 end
end

#~# EXPECTED

begin
  foo do 1 end
end

#~# ORIGINAL 

begin
  for x in y do 1 end
end

#~# EXPECTED

begin
  for x in y do 1 end
end

#~# ORIGINAL 

begin
  # foo

  1
end

#~# EXPECTED

begin
  # foo

  1
end
