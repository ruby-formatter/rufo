#~# ORIGINAL

for  x  in  y
 2
 end

#~# EXPECTED

for x in y do 2 end

#~# ORIGINAL

for  x , y  in  z
 1
 2
 end

#~# EXPECTED

for x, y in z
  1
  2
end

#~# ORIGINAL

for  x  in  y  do
 1
 2
 end

#~# EXPECTED

for x in y
  1
  2
end

#~# ORIGINAL bug_45

for i, in [[1,2]]
  1
  i.should == 1
end

#~# EXPECTED

for i in [[1, 2]]
  1
  i.should == 1
end

#~# ORIGINAL

for i,j, in [[1,2]]
  1
  i.should == 1
end

#~# EXPECTED

for i, j in [[1, 2]]
  1
  i.should == 1
end
