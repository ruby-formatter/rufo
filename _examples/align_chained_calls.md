---
title: "align\\_chained\\_calls"
permalink: "/examples/align_chained_calls/"
toc: true
sidebar:
  nav: "examples"
---

### align\_chained\_calls 1
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
### align\_chained\_calls 2
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
### align\_chained\_calls 3
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
### align\_chained\_calls 4
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
### align\_chained\_calls 5
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
### align\_chained\_calls 6
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
### align\_chained\_calls 7
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
### align\_chained\_calls 8
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
### align\_chained\_calls 9
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
### align\_chained\_calls 10
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
### align\_chained\_calls 11
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
### align\_chained\_calls 12
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
### align\_chained\_calls 13
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
### align\_chained\_calls 14
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
### align\_chained\_calls 15
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
### align\_chained\_calls 16
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
### align\_chained\_calls 17
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
### align\_chained\_calls 18
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
