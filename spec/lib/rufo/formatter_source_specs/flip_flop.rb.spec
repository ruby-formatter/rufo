#~# ORIGINAL
lines.filter_map { |ln| ln if ln == "<<<"..ln == ">>>" }

#~# EXPECTED
lines.filter_map { |ln| ln if ln == "<<<"..ln == ">>>" }
