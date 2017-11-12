---
title: "module"
permalink: "/examples/module/"
toc: true
sidebar:
  nav: "examples"
---

### unnamed 495
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
### unnamed 496
```ruby
# GIVEN
module Foo ; end
```
```ruby
# BECOMES
module Foo; end
```
### unnamed 497
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
### unnamed 498
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
