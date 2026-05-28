#~# ORIGINAL bare heredoc

<<EOS
foo
EOS

#~# EXPECTED
<<EOS
foo
EOS

#~# ORIGINAL assigned heredoc

x = <<EOS
foo
EOS

#~# EXPECTED
x = <<EOS
foo
EOS

#~# ORIGINAL dash heredoc with indented closing

x = <<-EOS
  foo
  EOS

#~# EXPECTED
x = <<-EOS
  foo
  EOS

#~# ORIGINAL squiggly heredoc preserves body

x = <<~EOS
  foo
EOS

#~# EXPECTED
x = <<~EOS
  foo
EOS

#~# ORIGINAL heredoc followed by another statement

x = <<EOS
foo
EOS
y = 1

#~# EXPECTED
x = <<EOS
foo
EOS
y = 1

#~# ORIGINAL heredoc with comment after closing

x = <<EOS
foo
EOS
# c
y = 1

#~# EXPECTED
x = <<EOS
foo
EOS
# c
y = 1
