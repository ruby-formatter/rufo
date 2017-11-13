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
