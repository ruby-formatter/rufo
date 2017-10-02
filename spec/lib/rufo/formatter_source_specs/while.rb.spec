#~# ORIGINAL

while 1 ; end

#~# EXPECTED

while 1; end

#~# ORIGINAL

while 1 ; 2 ; end

#~# EXPECTED

while 1; 2; end

#~# ORIGINAL

while 1
 end

#~# EXPECTED

while 1
end

#~# ORIGINAL

while 1
 2
 3
 end

#~# EXPECTED

while 1
  2
  3
end

#~# ORIGINAL

while 1  # foo
 2
 3
 end

#~# EXPECTED

while 1 # foo
  2
  3
end

#~# ORIGINAL

while 1 do  end

#~# EXPECTED

while 1 do end

#~# ORIGINAL

while 1 do  2  end

#~# EXPECTED

while 1 do 2 end

#~# ORIGINAL

begin
 while 1  do  2  end
 end

#~# EXPECTED

begin
  while 1 do 2 end
end
