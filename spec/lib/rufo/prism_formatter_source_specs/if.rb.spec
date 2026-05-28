#~# ORIGINAL indents body

if x
1
end

#~# EXPECTED
if x
  1
end

#~# ORIGINAL preserves already indented body

if x
  1
end

#~# EXPECTED
if x
  1
end

#~# ORIGINAL nested indents twice

if x
if y
1
end
end

#~# EXPECTED
if x
  if y
    1
  end
end

#~# ORIGINAL empty body

if x
end

#~# EXPECTED
if x
end
