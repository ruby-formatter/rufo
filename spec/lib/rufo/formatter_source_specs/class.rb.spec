#~# ORIGINAL

class   Foo
  end

#~# EXPECTED

class Foo
end

#~# ORIGINAL

class   Foo  < Bar
  end

#~# EXPECTED

class Foo < Bar
end

#~# ORIGINAL

class Foo
1
end

#~# EXPECTED

class Foo
  1
end

#~# ORIGINAL

class Foo  ;  end

#~# EXPECTED

class Foo; end

#~# ORIGINAL

class Foo;
  end

#~# EXPECTED

class Foo
end

#~# ORIGINAL

class Foo; 1; end
class Bar; 2; end

#~# EXPECTED

class Foo; 1; end
class Bar; 2; end

#~# ORIGINAL

class Foo; 1; end

class Bar; 2; end

#~# EXPECTED

class Foo; 1; end

class Bar; 2; end

#~# ORIGINAL multi_inline_definitions

class A; end; class B; end

#~# EXPECTED

class A; end
class B; end

#~# ORIGINAL multi_inline_definitions_with_comment

class A; end; class B; end; class C; end # comment

#~# EXPECTED

class A; end
class B; end
class C; end # comment
