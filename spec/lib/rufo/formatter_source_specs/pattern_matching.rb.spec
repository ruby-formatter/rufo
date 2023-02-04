#~# ORIGINAL

case   a
  in 1
   1
end

#~# EXPECTED
case a
in 1
  1
end

#~# ORIGINAL

case   a
  in 1
    1
   else
  2
end

#~# EXPECTED
case a
in 1
  1
else
  2
end

#~# ORIGINAL

begin
 case   a
 in 1
 2
 in 3
 4
  else
 5
 end
 end

#~# EXPECTED
begin
  case a
  in 1
    2
  in 3
    4
  else
    5
  end
end
