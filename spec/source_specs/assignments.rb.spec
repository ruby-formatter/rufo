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

#~# ORIGINAL assign to unless

a = unless 1 
 2 
 end

#~# EXPECTED

a = unless 1
      2
    end

#~# ORIGINAL assign to begin

a = begin
1 
 end

#~# EXPECTED

a = begin
  1
end

#~# ORIGINAL assign to case

a = case
 when 1 
 2 
 end

#~# EXPECTED

a = case
    when 1
      2
    end

#~# ORIGINAL assign to begin

a = begin
1
end

#~# EXPECTED

a = begin
  1
end

#~# ORIGINAL assign to begin rescue

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

#~# ORIGINAL

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

#~# ORIGINAL

a=1

#~# EXPECTED

a = 1

#~# ORIGINAL

a = \
  begin
    1
  end

#~# EXPECTED

a = begin
  1
end

#~# ORIGINAL assign to multiple statements in paren

a = (
 v=do_work
 do_work + 10
 )

#~# EXPECTED

a = (
  v = do_work
  do_work + 10
)

#~# ORIGINAL skip assignment to begin inside method
# this test has a problem because we track @column as if my_method hasn't broken until it breaks inside the group.
# we'll need to resolve this test

def my_method; a = begin; 2; rescue; 4; end; end

#~# EXPECTED

def my_method
  a = begin
    2
  rescue
    4
  end
end
