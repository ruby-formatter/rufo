#~# ORIGINAL

-> { }

#~# EXPECTED

-> { }

#~# ORIGINAL

->{ }

#~# EXPECTED

-> { }

#~# ORIGINAL

->{   1   }

#~# EXPECTED

-> { 1 }

#~# ORIGINAL

->{   1 ; 2  }

#~# EXPECTED

-> do
  1
  2
end

#~# ORIGINAL

->{   1
 2  }

#~# EXPECTED

-> do
  1
  2
end

#~# ORIGINAL

-> do  1
 2  end

#~# EXPECTED

-> do
  1
  2
end

#~# ORIGINAL

->do  1
 2  end

#~# EXPECTED

-> do
  1
  2
end

#~# ORIGINAL

->( x ){ }

#~# EXPECTED

-> (x) { }
