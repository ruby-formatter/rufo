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

