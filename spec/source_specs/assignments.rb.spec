#~# ORIGINAL simple assignment

a   =   1

#~# EXPECTED

a = 1

#~# ORIGINAL assignment with newline

a   =  
2

#~# EXPECTED

a = 2

#~# ORIGINAL skip  assignment with comment

a   =   # hello 
2

#~# EXPECTED

a = # hello
  2

#~# ORIGINAL assignment with line length
#~# line_length: 10

a_really_long_variable_name=1

#~# EXPECTED

a_really_long_variable_name =
  1

#~# ORIGINAL assign to if

a = if 1 
 2 
 end

#~# EXPECTED

a = if 1
      2
    end

#~# ORIGINAL skip 

a = unless 1 
 2 
 end

#~# EXPECTED

a = unless 1
      2
    end

#~# ORIGINAL skip 

a = begin
1 
 end

#~# EXPECTED

a = begin
  1
end

#~# ORIGINAL skip 

a = case
 when 1 
 2 
 end

#~# EXPECTED

a = case
    when 1
      2
    end

#~# ORIGINAL skip 

a = begin
1
end

#~# EXPECTED

a = begin
  1
end

#~# ORIGINAL skip 

a = begin
1
rescue
2
end

#~# EXPECTED

a = begin
      1
    rescue
      2
    end

#~# ORIGINAL skip 

a = begin
1
ensure
2
end

#~# EXPECTED

a = begin
      1
    ensure
      2
    end

#~# ORIGINAL skip 

a=1

#~# EXPECTED

a=1

#~# ORIGINAL skip 

a = \
  begin
    1
  end

#~# EXPECTED

a =
  begin
    1
  end
