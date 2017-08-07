#~# ORIGINAL
#~# spaces_around_when: :one

case 1
when  2  then  3
else  4
end

#~# EXPECTED

case 1
when 2 then 3
else 4
end

#~# ORIGINAL
#~# spaces_around_when: :dynamic

case 1
when  2  then  3
else  4
end

#~# EXPECTED

case 1
when  2  then  3
else  4
end

