#~# ORIGINAL

case 1
  in 1
  in 2
    puts '2'
 else
  puts '3'
end

#~# EXPECTED
case 1
in 1
in 2
  puts "2"
else
  puts "3"
end

#~# ORIGINAL

case ['xxx',2]
  in [_,a]
    puts a
  end

#~# EXPECTED
case ["xxx", 2]
in [_, a]
  puts a
end

#~# ORIGINAL

case Dry::Monads::Maybe(nil)
   in Dry::Monads::Some(x)
    puts x
 in Dry::Monads::None
   puts "2"
  end

#~# EXPECTED
case Dry::Monads::Maybe(nil)
in Dry::Monads::Some(x)
  puts x
in Dry::Monads::None
  puts "2"
end

#~# ORIGINAL

case 0
  in 0 => a
    a == 0
  end

#~# EXPECTED
case 0
in 0 => a
  a == 0
end

#~# ORIGINAL

case {a:0, b: 1}
in a:, b:
p a
p b
end

#~# EXPECTED
case { a: 0, b: 1 }
in a:, b:
  p a
  p b
end

#~# ORIGINAL

def test
  case 0
    in 0 => a
      a == 0
    end
end

#~# EXPECTED
def test
  case 0
  in 0 => a
    a == 0
  end
end
