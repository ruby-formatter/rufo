#~# ORIGINAL

for  x  in  y
 2
 end

#~# EXPECTED

for x in y
  2
end

#~# ORIGINAL

for  x , y  in  z
 2
 end

#~# EXPECTED

for x, y in z
  2
end

#~# ORIGINAL

for  x  in  y  do
 2
 end

#~# EXPECTED

for x in y
  2
end

#~# ORIGINAL
#~# PENDING

for i, in [[1,2]]
  i.should == 1
end

#~# EXPECTED

for i, in [[1,2]]
  i.should == 1
end
