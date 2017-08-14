#~# ORIGINAL
#~# align_case_when: true

case
 when 1 then 2
 when 234 then 5 
 else 6
 end

#~# EXPECTED

case
when 1   then 2
when 234 then 5
else          6
end

#~# ORIGINAL
#~# align_case_when: true

case
 when 1; 2
 when 234; 5 
 end

#~# EXPECTED

case
when 1;   2
when 234; 5
end

#~# ORIGINAL
#~# align_case_when: true

case
 when 1; 2
 when 234; 5 
 else 6
 end

#~# EXPECTED

case
when 1;   2
when 234; 5
else      6
end

#~# ORIGINAL
#~# align_case_when: false

case
 when 1 then 2
 when 234 then 5 
 else 6 
 end

#~# EXPECTED

case
when 1 then 2
when 234 then 5
else 6
end

