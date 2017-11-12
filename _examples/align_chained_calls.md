---
title: "align\\_chained\\_calls"
permalink: "/examples/align_chained_calls/"
toc: true
sidebar:
  nav: "examples"
---

### unnamed 17
```ruby
# GIVEN
foo . bar
 . baz
```
```ruby
# BECOMES
foo.bar
  .baz
```
```ruby
# with setting `align_chained_calls true`
foo.bar
   .baz
```
### unnamed 18
```ruby
# GIVEN
foo . bar
 . baz
 . qux
```
```ruby
# BECOMES
foo.bar
  .baz
  .qux
```
```ruby
# with setting `align_chained_calls true`
foo.bar
   .baz
   .qux
```
### unnamed 19
```ruby
# GIVEN
foo . bar( x.y )
 . baz
 . qux
```
```ruby
# BECOMES
foo.bar(x.y)
  .baz
  .qux
```
```ruby
# with setting `align_chained_calls true`
foo.bar(x.y)
   .baz
   .qux
```
### unnamed 20
```ruby
# GIVEN
x.foo
 .bar { a.b }
 .baz
```
```ruby
# BECOMES
x.foo
 .bar { a.b }
 .baz
```
### unnamed 21
```ruby
# GIVEN
a do #
  b
    .w y(x)
         .z
end
```
```ruby
# BECOMES
a do #
  b.w y(x)
        .z
end
```
### unnamed 22
```ruby
# GIVEN
a do #
  b #
    .w y(x)
         .z
end
```
```ruby
# BECOMES
a do #
  b #
    .w y(x)
         .z
end
```
### unnamed 23
```ruby
# GIVEN
a do #
  b #
    .w y(x) #
         .z
end
```
```ruby
# BECOMES
a do #
  b #
    .w y(x) #
         .z
end
```
### unnamed 24
```ruby
# GIVEN
a do
  b #
    .w x
end
```
```ruby
# BECOMES
a do
  b #
    .w x
end
```
### unnamed 25
```ruby
# GIVEN
a
  .b
  .c
  .d
```
```ruby
# BECOMES
a
  .b
  .c
  .d
```
### unnamed 26
```ruby
# GIVEN
a do
  b #
    .w x
         .z
end
```
```ruby
# BECOMES
a do
  b #
    .w x
         .z
end
```
### unnamed 27
```ruby
# GIVEN
a {
  b #
    .w x
         .z
}
```
```ruby
# BECOMES
a {
  b #
    .w x
         .z
}
```
### unnamed 28
```ruby
# GIVEN
a {
  b x #
      .w
      .z
}
```
```ruby
# BECOMES
a {
  b x #
      .w
      .z
}
```
### unnamed 29
```ruby
# GIVEN
a do
  b #
    .w
end
```
```ruby
# BECOMES
a do
  b #
    .w
end
```
### unnamed 30
```ruby
# GIVEN
b #
  .w
```
```ruby
# BECOMES
b #
  .w
```
### unnamed 31
```ruby
# GIVEN
a do
  b #
    .w
end
```
```ruby
# BECOMES
a do
  b #
    .w
end
```
### unnamed 32
```ruby
# GIVEN
a do
  b#
    .w x
end
```
```ruby
# BECOMES
a do
  b #
    .w x
end
```
### unnamed 33
```ruby
# GIVEN
a b do
  c d do
    e #
      .f g
           .h
           .i
  end
end
```
```ruby
# BECOMES
a b do
  c d do
    e #
      .f g
           .h
           .i
  end
end
```
### unnamed 34
```ruby
# GIVEN
context 'b123' do
  it 'd123' do
    expect_any_instance_of(Uploader::Null) # some comment
      .f123 g123(h123)
              .h123
              .i123
  end
end
```
```ruby
# BECOMES
context 'b123' do
  it 'd123' do
    expect_any_instance_of(Uploader::Null) # some comment
      .f123 g123(h123)
              .h123
              .i123
  end
end
```
### bug_49
```ruby
# GIVEN
context 'no sidecar/archive' do
  it 'uploads destination master to the specified destination' do
    expect_any_instance_of(Uploader::Null) # rubocop:disable RSpec/AnyInstance
      .to receive(:upload)
            .with([file_path, 'HON_TEST001_010.mxf'])
            .and_return(Uploader::Result.new(success: true))
  end
end
```
```ruby
# BECOMES
context 'no sidecar/archive' do
  it 'uploads destination master to the specified destination' do
    expect_any_instance_of(Uploader::Null) # rubocop:disable RSpec/AnyInstance
      .to receive(:upload)
            .with([file_path, 'HON_TEST001_010.mxf'])
            .and_return(Uploader::Result.new(success: true))
  end
end
```
