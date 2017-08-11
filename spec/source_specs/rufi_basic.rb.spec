#~# ORIGINAL

var='hello'

#~# EXPECTED

var = 'hello'

#~# ORIGINAL single variable

var='hello'

#~# EXPECTED

var = 'hello'

#~# ORIGINAL two variable assignments

var='hello'
var='hello'

#~# EXPECTED

var = 'hello'
var = 'hello'

#~# ORIGINAL two variable assignments with newline

var='hello'

var='hello'

#~# EXPECTED

var = 'hello'

var = 'hello'

#~# ORIGINAL long variable assignment

var='ssuper-super-super-super-duper-long-stringsuper-super-super-super-duper-long-stringuper-super-super-super-duper-long-string'

#~# EXPECTED

var =
  'ssuper-super-super-super-duper-long-stringsuper-super-super-super-duper-long-stringuper-super-super-super-duper-long-string'

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

#~# ORIGINAL method with arguments and useless spaces beforehand

def hello                                 arg
  arg
end

#~# EXPECTED

def hello(arg)
  arg
end

#~# ORIGINAL empty method into one liner

def empty
end

#~# EXPECTED

def empty; end

#~# ORIGINAL basic method

def hello; 'world'; end

#~# EXPECTED

def hello
  'world'
end

#~# ORIGINAL multiple statements inside method

def hello; var='var'; van='van'; end

#~# EXPECTED

def hello
  var = 'var'
  van = 'van'
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

#~# ORIGINAL multiple one-liner methods inside method

def hello

  def method_inside;       end
  def sherpa
  end
end

#~# EXPECTED

def hello
  def method_inside; end

  def sherpa; end
end

#~# ORIGINAL one-line separated statements inside a method

def hello
  'ok'

  'ok'
end

#~# EXPECTED

def hello
  'ok'

  'ok'
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
      "that you"
    end
  end
end

#~# ORIGINAL double nested methods

def hello(arg)
  def its_me(arg2)
    def i_heard(arg3)
      "that you"
    end
  end
end

#~# EXPECTED

def hello(arg)
  def its_me(arg2)
    def i_heard(arg3)
      "that you"
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

def say_hi(name,   time)
  name
end

#~# EXPECTED

def say_hi(name, time)
  name
end

#~# ORIGINAL small hash

x =          { a: :a }

#~# EXPECTED

x = { a: :a }

#~# ORIGINAL nested hash

x = { a: { b: :b,   c: :c }, b: :b, c: { d: :d, e: :e, f: :f, g: { h: :h, i: :i, j: :j, k: :k, inner_last: :inner_last } }, d: :d, e: { f: :f, g: :g, h: :h }, f: { g: :g, h: :h } }

#~# EXPECTED

x = {
  a: { b: :b, c: :c },
  b: :b,
  c: {
    d: :d,
    e: :e,
    f: :f,
    g: {
      h: :h,
      i: :i,
      j: :j,
      k: :k,
      inner_last: :inner_last,
    },
  },
  d: :d,
  e: {
    f: :f,
    g: :g,
    h: :h,
  },
  f: {
    g: :g,
    h: :h,
  },
}

#~# ORIGINAL big hash

x = { a: :a, b: :b, c: :c, d: :d, e: :e, f: :f, g: :g, h: :h, i: :i, j: :j, k: :k, l: :l, m: :m, n: :n, o: :o, p: :p, q: :q }

#~# EXPECTED

x = {
  a: :a,
  b: :b,
  c: :c,
  d: :d,
  e: :e,
  f: :f,
  g: :g,
  h: :h,
  i: :i,
  j: :j,
  k: :k,
  l: :l,
  m: :m,
  n: :n,
  o: :o,
  p: :p,
  q: :q,
}

#~# ORIGINAL method with many parameters

def big_method(one, two, three, four, five, six, seven, eight, nine, ten, eleven, twelve, thirteen, fourteen, fifteen)
  'ok'
end

#~# EXPECTED

def big_method(
  one,
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  nine,
  ten,
  eleven,
  twelve,
  thirteen,
  fourteen,
  fifteen
)
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

#~# ORIGINAL a test of judgement

def big_method(one, two, three, four, five, six, seven, eight, nine, ten, eleven, twelve, thirteen, fourteen, fifteen)
  'ok'

  def inner_method(no_break_needed)
    no_break_needed
    'ok'
  end
end

#~# EXPECTED

def big_method(
  one,
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  nine,
  ten,
  eleven,
  twelve,
  thirteen,
  fourteen,
  fifteen
)
  'ok'

  def inner_method(no_break_needed)
    no_break_needed
    'ok'
  end
end

#~# ORIGINAL another

var = "my extremely long string that should definintely break when we attempt to rebuild it. I mean, I'm long enough right? I sure hope so"
var = "no break plz"

#~# EXPECTED

var =
  "my extremely long string that should definintely break when we attempt to rebuild it. I mean, I'm long enough right? I sure hope so"
var = "no break plz"

#~# ORIGINAL array literal

var=[ ]

#~# EXPECTED

var = []

#~# ORIGINAL array literal with strings

var=['ok','hello']

#~# EXPECTED

var = ['ok', 'hello']

#~# ORIGINAL array literal with numbers

var=[1,5,'ok']

#~# EXPECTED

var = [1, 5, 'ok']

#~# ORIGINAL long array literal

var=[1,'this is a super duper long string that will push us way over the top. give me a break dude', 'why is this array so long?',5,'ok']

#~# EXPECTED

var = [
  1,
  'this is a super duper long string that will push us way over the top. give me a break dude',
  'why is this array so long?',
  5,
  'ok',
]

#~# ORIGINAL empty begin

begin
end

#~# EXPECTED

begin; end

#~# ORIGINAL begin

begin
  'begin'
end

#~# EXPECTED

begin
  'begin'
end

#~# ORIGINAL begin rescue end

begin
  'begin rescue end'
rescue
  10
end

#~# EXPECTED

begin
  'begin rescue end'
rescue
  10
end

#~# ORIGINAL begin rescue type end

begin
  'begin rescue end'
rescue KeyError
  10
end

#~# EXPECTED

begin
  'begin rescue end'
rescue KeyError
  10
end

#~# ORIGINAL begin rescue multiple types end

begin
  'begin rescue end'
rescue KeyError, RuntimeError
  10
end

#~# EXPECTED

begin
  'begin rescue end'
rescue KeyError, RuntimeError
  10
end

#~# ORIGINAL begin rescue type assignment end

begin
  'begin rescue end'
rescue KeyError => e
  10
end

#~# EXPECTED

begin
  'begin rescue end'
rescue KeyError => e
  10
end
