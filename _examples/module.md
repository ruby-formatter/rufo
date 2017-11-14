---
title: "module"
permalink: "/examples/module/"
toc: true
sidebar:
  nav: "examples"
---

### module 1
```ruby
# GIVEN
module   Foo  
  end
```
```ruby
# BECOMES
module Foo
end
```
### module 2
```ruby
# GIVEN
module Foo ; end
```
```ruby
# BECOMES
module Foo; end
```
### module 3
```ruby
# GIVEN
module Foo; 1; end
module Bar; 2; end
```
```ruby
# BECOMES
module Foo; 1; end
module Bar; 2; end
```
### module 4
```ruby
# GIVEN
module Foo; 1; end

module Bar; 2; end
```
```ruby
# BECOMES
module Foo; 1; end

module Bar; 2; end
```
### multi_inline_definitions
```ruby
# GIVEN
module A; end; module B; end
```
```ruby
# BECOMES
module A; end
module B; end
```
### multi_inline_definitions_2
```ruby
# GIVEN
module A a end; module B b end; module C c end
```
```ruby
# BECOMES
module A a end
module B b end
module C c end
```
### multi_inline_definitions_3
```ruby
# GIVEN
module A end; module B end
```
```ruby
# BECOMES
module A end
module B end
```
### multi_inline_definitions_4
```ruby
# GIVEN
module A a end; module B b end; module C c end
```
```ruby
# BECOMES
module A a end
module B b end
module C c end
```
### multi_inline_definitions_with_comment
```ruby
# GIVEN
module A end; module B end; module C end # comment
```
```ruby
# BECOMES
module A end
module B end
module C end # comment
```
### multi_inline_definitions_with_comment_2
```ruby
# GIVEN
module A;a end; module B;b end; module C;c end # comment
```
```ruby
# BECOMES
module A; a end
module B; b end
module C; c end # comment
```
