#~# ORIGINAL
#~# spaces_inside_array_bracket: :never

[ 1 ]

#~# EXPECTED

[1]

#~# ORIGINAL
#~# spaces_inside_array_bracket: :always

[1]

#~# EXPECTED

[ 1 ]

#~# ORIGINAL
#~# spaces_inside_array_bracket: :dynamic

[1]

#~# EXPECTED

[1]

#~# ORIGINAL
#~# spaces_inside_array_bracket: :dynamic

[ 1]

#~# EXPECTED

[ 1]

#~# ORIGINAL
#~# spaces_inside_array_bracket: :dynamic

[  1, 2   ]

#~# EXPECTED

[  1, 2   ]

#~# ORIGINAL
#~# spaces_inside_array_bracket: :match

[   1, 2]

#~# EXPECTED

[ 1, 2 ]

#~# ORIGINAL
#~# spaces_inside_array_bracket: :match

[1, 2   ]

#~# EXPECTED

[1, 2]

#~# ORIGINAL
#~# spaces_inside_array_bracket: :dynamic

a[ 1  ]

#~# EXPECTED

a[ 1  ]

