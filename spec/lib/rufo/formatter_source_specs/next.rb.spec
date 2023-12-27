#~# ORIGINAL next
loop do

next
end

#~# EXPECTED
loop do
  next
end

#~# ORIGINAL
loop do

next  1
end

#~# EXPECTED
loop do
  next 1
end

#~# ORIGINAL
loop do

next  1 , 2
end

#~# EXPECTED
loop do
  next 1, 2
end

#~# ORIGINAL
loop do

next  1 ,
 2
end

#~# EXPECTED
loop do
  next 1,
       2
end

