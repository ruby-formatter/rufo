#~# ORIGINAL break
loop do

break
end

#~# EXPECTED
loop do
  break
end

#~# ORIGINAL
loop do

break  1
end

#~# EXPECTED
loop do
  break 1
end

#~# ORIGINAL
loop do
break  1 , 2
end

#~# EXPECTED
loop do
  break 1, 2
end

#~# ORIGINAL
loop do

break  1 ,
 2
end

#~# EXPECTED
loop do
  break 1,
        2
end
