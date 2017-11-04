#~# ORIGINAL

class Foo

1

end

#~# EXPECTED

class Foo
  1
end

#~# ORIGINAL
#~# double_newline_inside_type: :yes

class Foo

1

end

#~# EXPECTED

class Foo

  1

end

#~# ORIGINAL
#~# double_newline_inside_type: :yes

class Foo


1


end

#~# EXPECTED

class Foo

  1

end

