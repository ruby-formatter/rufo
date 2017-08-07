#~# ORIGINAL
#~# double_newline_inside_type: :no

class Foo

1

end

#~# EXPECTED

class Foo
  1
end

#~# ORIGINAL
#~# double_newline_inside_type: :dynamic

class Foo

1

end

#~# EXPECTED

class Foo

  1

end

