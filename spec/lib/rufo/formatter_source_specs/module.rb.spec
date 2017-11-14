#~# ORIGINAL 

module   Foo  
  end

#~# EXPECTED

module Foo
end

#~# ORIGINAL 

module Foo ; end

#~# EXPECTED

module Foo; end

#~# ORIGINAL 

module Foo; 1; end
module Bar; 2; end

#~# EXPECTED

module Foo; 1; end
module Bar; 2; end

#~# ORIGINAL 

module Foo; 1; end

module Bar; 2; end

#~# EXPECTED

module Foo; 1; end

module Bar; 2; end

#~# ORIGINAL multi_inline_definitions

module A; end; module B; end

#~# EXPECTED

module A; end
module B; end

#~# ORIGINAL multi_inline_definitions_2

module A a end; module B b end; module C c end

#~# EXPECTED

module A a end
module B b end
module C c end

#~# ORIGINAL multi_inline_definitions_3

module A end; module B end

#~# EXPECTED

module A end
module B end

#~# ORIGINAL multi_inline_definitions_4

module A a end; module B b end; module C c end

#~# EXPECTED

module A a end
module B b end
module C c end

#~# ORIGINAL multi_inline_definitions_with_comment

module A end; module B end; module C end # comment

#~# EXPECTED

module A end
module B end
module C end # comment

#~# ORIGINAL multi_inline_definitions_with_comment_2

module A;a end; module B;b end; module C;c end # comment

#~# EXPECTED

module A; a end
module B; b end
module C; c end # comment

