#~# ORIGINAL

URI(string) rescue nil

#~# EXPECTED
URI(string) rescue nil

#~# ORIGINAL

URI(string) while nil

#~# EXPECTED
URI(string) while nil

#~# ORIGINAL

URI(string) if nil

#~# EXPECTED
URI(string) if nil

#~# ORIGINAL

URI(string) unless nil

#~# EXPECTED
URI(string) unless nil

#~# ORIGINAL
a, b = raise rescue [1, 2]

#~# EXPECTED
a, b = raise rescue [1, 2]
