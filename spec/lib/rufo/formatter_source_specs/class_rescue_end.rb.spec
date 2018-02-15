#~# ORIGINAL

  class Foo
 raise "bar"
 rescue Baz =>  ex
 end

#~# EXPECTED

class Foo
  raise "bar"
rescue Baz => ex
end
