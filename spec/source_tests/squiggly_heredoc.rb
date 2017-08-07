#~# ORIGINAL 

[
  [<<~'},'] # comment
  },
]

#~# EXPECTED

[
  [<<~'},'], # comment
  },
]

#~# ORIGINAL 

[
  [<<~'},'], # comment
  },
]

#~# EXPECTED

[
  [<<~'},'], # comment
  },
]

#~# ORIGINAL 

[
  [<<~'},'], # comment
  },
  2,
]

#~# EXPECTED

[
  [<<~'},'], # comment
  },
  2,
]

#~# ORIGINAL 

[
  [<<~EOF] # comment
  EOF
]

#~# EXPECTED

[
  [<<~EOF], # comment
  EOF
]

#~# ORIGINAL 

begin
  foo = <<~STR
    some

    thing
  STR
end

#~# EXPECTED

begin
  foo = <<~STR
    some

    thing
  STR
end

#~# ORIGINAL 

<<~EOF
  foo
   bar
EOF

#~# EXPECTED

<<~EOF
  foo
   bar
EOF

#~# ORIGINAL 

<<~EOF
  #{1}
   bar
EOF

#~# EXPECTED

<<~EOF
  #{1}
   bar
EOF

#~# ORIGINAL 

begin 
 <<~EOF
  foo
   bar
EOF
 end

#~# EXPECTED

begin
  <<~EOF
    foo
     bar
  EOF
end

