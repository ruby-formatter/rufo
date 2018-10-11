#~# ORIGINAL

 def foo .
 bar; end

#~# EXPECTED

def foo.bar; end

#~# ORIGINAL

 def foo ::
 bar; end

#~# EXPECTED

def foo::bar; end

#~# ORIGINAL

 def self .
 bar; end

#~# EXPECTED

def self.bar; end

#~# ORIGINAL

 def self ::
 bar; end

#~# EXPECTED

def self::bar; end

#~# ORIGINAL

module Foo
  def Foo ::
bar; end; end

#~# EXPECTED

module Foo
  def Foo::bar; end
end

#~# ORIGINAL multi_inline_definitions

def foo(x); end; def bar(y); end

#~# EXPECTED

def foo(x); end
def bar(y); end

#~# ORIGINAL  multi_inline_definitions_2

def foo(x); x end; def bar(y); y end

#~# EXPECTED

def foo(x); x end
def bar(y); y end

#~# ORIGINAL  multi_inline_definitions_with_comment

def a x;x end;def b y;y end;def c z;z end # comment

#~# EXPECTED

def a(x); x end
def b(y); y end
def c(z); z end # comment
