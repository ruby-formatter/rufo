#~# ORIGINAL return

return

#~# EXPECTED

return

#~# ORIGINAL

return  1

#~# EXPECTED

return 1

#~# ORIGINAL

return  1 , 2

#~# EXPECTED

return 1, 2

#~# ORIGINAL

return  1 ,
 2

#~# EXPECTED

return 1, 2

#~# ORIGINAL

return a b

#~# EXPECTED

return a b

#~# ORIGINAL
#~# print_width: 50

return {
  formatted: before_cursor + after_cursor,
  cursor: before_cursor.length,
}

#~# EXPECTED

return {
  formatted: before_cursor + after_cursor,
  cursor: before_cursor.length,
}
