#~# ORIGINAL 

URI(string) rescue return

#~# EXPECTED

URI(string) rescue return

#~# ORIGINAL 

URI(string) while return

#~# EXPECTED

URI(string) while return

#~# ORIGINAL 

URI(string) if return

#~# EXPECTED

URI(string) if return

#~# ORIGINAL 

URI(string) unless return

#~# EXPECTED

URI(string) unless return
