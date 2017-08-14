#~# ORIGINAL
#~# spaces_after_lambda_arrow: :dynamic

->  { }

#~# EXPECTED

->  { }

#~# ORIGINAL
#~# spaces_after_lambda_arrow: :no

->  { }

#~# EXPECTED

->{ }

#~# ORIGINAL
#~# spaces_after_lambda_arrow: :one

->  { }

#~# EXPECTED

-> { }

#~# ORIGINAL
#~# spaces_after_lambda_arrow: :one

->{ }

#~# EXPECTED

-> { }

