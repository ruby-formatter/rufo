---
title: "inline\\_classes (v2.3 +)"
permalink: "/examples/inline_classes/"
toc: true
sidebar:
  nav: "examples"
---

### multi_inline_definitions
```ruby
# GIVEN
class A end; class B end
```
```ruby
# BECOMES
class A end
class B end
```
### multi_inline_definitions_with_comment
```ruby
# GIVEN
class A end; class B end; class C end # comment
```
```ruby
# BECOMES
class A end
class B end
class C end # comment
```
