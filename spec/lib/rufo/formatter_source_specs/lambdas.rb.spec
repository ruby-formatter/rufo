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

-> { 1; 2 }

#~# ORIGINAL

->{   1
 2  }

#~# EXPECTED

-> {
  1
  2
}

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

#~# ORIGINAL

a :b, lambda {
  case a
  when nil
  else
  end
}

#~# EXPECTED

a :b, lambda {
  case a
  when nil
  else
  end
}
