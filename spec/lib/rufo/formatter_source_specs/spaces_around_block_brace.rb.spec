#~# ORIGINAL
#~# spaces_around_block_brace: :one

foo{1}

#~# EXPECTED

foo { 1 }

#~# ORIGINAL
#~# spaces_around_block_brace: :one

foo{|x|1}

#~# EXPECTED

foo { |x| 1 }

#~# ORIGINAL
#~# spaces_around_block_brace: :dynamic

foo{1}

#~# EXPECTED

foo{1}

#~# ORIGINAL
#~# spaces_around_block_brace: :dynamic

foo{|x|1}

#~# EXPECTED

foo{|x|1}

#~# ORIGINAL
#~# spaces_around_block_brace: :one

foo  {  1  }

#~# EXPECTED

foo { 1 }

#~# ORIGINAL
#~# spaces_around_block_brace: :dynamic

foo  {  1  }

#~# EXPECTED

foo  {  1  }

#~# ORIGINAL
#~# spaces_around_block_brace: :dynamic

->{1}

#~# EXPECTED

-> {1}

#~# ORIGINAL
#~# spaces_around_block_brace: :one

->{1}

#~# EXPECTED

-> { 1 }

