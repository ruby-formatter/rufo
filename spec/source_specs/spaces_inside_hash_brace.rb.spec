#~# ORIGINAL
#~# spaces_inside_hash_brace: :never

{ 1 => 2 }

#~# EXPECTED

{1 => 2}

#~# ORIGINAL
#~# spaces_inside_hash_brace: :always

{1 => 2}

#~# EXPECTED

{ 1 => 2 }

#~# ORIGINAL
#~# spaces_inside_hash_brace: :dynamic

{  1 => 2   }

#~# EXPECTED

{  1 => 2   }

#~# ORIGINAL
#~# spaces_inside_hash_brace: :match

{1 => 2  }

#~# EXPECTED

{1 => 2}

#~# ORIGINAL
#~# spaces_inside_hash_brace: :match

{  1 => 2}

#~# EXPECTED

{ 1 => 2 }

#~# ORIGINAL
#~# spaces_inside_hash_brace: :match

{  1 => 2   }

#~# EXPECTED

{ 1 => 2 }

