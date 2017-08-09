#~# ORIGINAL

'hello'

#~# EXPECTED

'hello'

#~# ORIGINAL

"hello"
"hello"

#~# EXPECTED

'hello'
'hello'

#~# ORIGINAL

"hello #{name}"

#~# EXPECTED

"hello #{name}"

#~# ORIGINAL

var='hello'

#~# EXPECTED

var = 'hello'

# #~# ORIGINAL single variable
# 
# var='hello'
# 
# #~# EXPECTED
# 
# var =
#   'hello'
# 
#~# ORIGINAL two variable assignments

var='hello'
var='hello'

#~# EXPECTED

var = 'hello'
var = 'hello'

# #~# ORIGINAL long variable assignment
# 
# var='ssuper-super-super-super-duper-long-stringsuper-super-super-super-duper-long-stringuper-super-super-super-duper-long-string'
# 
# #~# EXPECTED
# 
# var =
#   'ssuper-super-super-super-duper-long-stringsuper-super-super-super-duper-long-stringuper-super-super-super-duper-long-string'
# 
#~# ORIGINAL

var='hello';van='goodbye';

#~# EXPECTED

var = 'hello'
van = 'goodbye'

#~# ORIGINAL method with no arguments

def hello; 'world'; end

#~# EXPECTED

def hello
  'world'
end

#~# ORIGINAL basic method

def hello
  'world'
end

#~# EXPECTED

def hello
  'world'
end

#~# ORIGINAL method inside method

def hello
  def method_inside
    'world'
  end
end

#~# EXPECTED

def hello
  def method_inside
    'world'
  end
end

#~# ORIGINAL multiple methods inside method

def hello
  def method_inside
    'hello'
  end
  def second_method
    'world'
  end
end

#~# EXPECTED

def hello
  def method_inside
    'hello'
  end

  def second_method
    'world'
  end
end

#~# ORIGINAL double nested methods

def hello
  def its_me
    def i_heard
      "that you"
    end
  end
end

#~# EXPECTED

def hello
  def its_me
    def i_heard
      'that you'
    end
  end
end

#~# ORIGINAL method with one argument

def say_hi(name)
  name
end

#~# EXPECTED

def say_hi(name)
  name
end

#~# ORIGINAL method with arguments

def say_hi(name, time)
  name
end

#~# EXPECTED

def say_hi(name, time)
  name
end

#~# ORIGINAL method with many parameters

def big_method(one, two, three, four, five, six, seven, eight, nine)
  'ok'
end

#~# EXPECTED

def big_method(one, two, three, four, five, six, seven, eight, nine)
  'ok'
end
 
#~# ORIGINAL statements inside a method

def my_method
  var='hello'; var='hello'
end

#~# EXPECTED

def my_method
  var = 'hello'
  var = 'hello'
end
