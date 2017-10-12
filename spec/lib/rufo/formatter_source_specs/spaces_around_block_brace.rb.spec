#~# ORIGINAL

foo{1}

#~# EXPECTED

foo { 1 }

#~# ORIGINAL

foo{|x|1}

#~# EXPECTED

foo { |x| 1 }

#~# ORIGINAL

foo  {  1  }

#~# EXPECTED

foo { 1 }

#~# ORIGINAL

->{1}

#~# EXPECTED

-> { 1 }

