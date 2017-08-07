#~# ORIGINAL string_literal_i_dont_think_these_are_good_tests_percent_string_concatenation_1

"foo"   "bar"

#~# EXPECTED

"foo" "bar"

#~# ORIGINAL string_literal_i_dont_think_these_are_good_tests_percent_string_concatenation_2

"foo" \
 "bar"

#~# EXPECTED

"foo" \
"bar"

#~# ORIGINAL string_literal_i_dont_think_these_are_good_tests_percent_string_concatenation_3

x 1, "foo" \
     "bar"

#~# EXPECTED

x 1, "foo" \
     "bar"

