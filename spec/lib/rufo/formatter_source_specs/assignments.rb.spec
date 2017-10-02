#~# ORIGINAL

a   =   1

#~# EXPECTED

a = 1

#~# ORIGINAL

a   =
2

#~# EXPECTED

a =
  2

#~# ORIGINAL

a   =   # hello
2

#~# EXPECTED

a = # hello
  2

#~# ORIGINAL

a = if 1
 2
 end

#~# EXPECTED

a = if 1
      2
    end

#~# ORIGINAL

a = unless 1
 2
 end

#~# EXPECTED

a = unless 1
      2
    end

#~# ORIGINAL

a = begin
1
 end

#~# EXPECTED

a = begin
  1
end

#~# ORIGINAL

a = case
 when 1
 2
 end

#~# EXPECTED

a = case
    when 1
      2
    end

#~# ORIGINAL

a = begin
1
end

#~# EXPECTED

a = begin
  1
end

#~# ORIGINAL

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

a =
  begin
    1
  end
