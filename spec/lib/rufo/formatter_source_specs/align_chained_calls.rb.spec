#~# ORIGINAL
#~# align_chained_calls: true

foo . bar
 . baz

#~# EXPECTED

foo.bar
   .baz

#~# ORIGINAL
#~# align_chained_calls: true

foo . bar
 . baz
 . qux

#~# EXPECTED

foo.bar
   .baz
   .qux

#~# ORIGINAL
#~# align_chained_calls: true

foo . bar( x.y )
 . baz
 . qux

#~# EXPECTED

foo.bar(x.y)
   .baz
   .qux

#~# ORIGINAL

x.foo
 .bar { a.b }
 .baz

#~# EXPECTED

x.foo
 .bar { a.b }
 .baz

#~# ORIGINAL

a do #
  b
    .w y(x)
         .z
end

#~# EXPECTED

a do #
  b.w y(x)
        .z
end

#~# ORIGINAL

a do #
  b #
    .w y(x)
         .z
end

#~# EXPECTED

a do #
  b #
    .w y(x)
         .z
end

#~# ORIGINAL

a do #
  b #
    .w y(x) #
         .z
end

#~# EXPECTED

a do #
  b #
    .w y(x) #
         .z
end

#~# ORIGINAL

a do
  b #
    .w x
end

#~# EXPECTED

a do
  b #
    .w x
end

#~# ORIGINAL

a
  .b
  .c
  .d

#~# EXPECTED

a
  .b
  .c
  .d

#~# ORIGINAL

a do
  b #
    .w x
         .z
end

#~# EXPECTED

a do
  b #
    .w x
         .z
end

#~# ORIGINAL

a {
  b #
    .w x
         .z
}

#~# EXPECTED

a {
  b #
    .w x
         .z
}

#~# ORIGINAL

a {
  b x #
      .w
      .z
}

#~# EXPECTED

a {
  b x #
      .w
      .z
}

#~# ORIGINAL

a do
  b #
    .w
end

#~# EXPECTED

a do
  b #
    .w
end

#~# ORIGINAL

b #
  .w

#~# EXPECTED

b #
  .w

#~# ORIGINAL

a do
  b #
    .w
end

#~# EXPECTED

a do
  b #
    .w
end

#~# ORIGINAL

a do
  b#
    .w x
end

#~# EXPECTED

a do
  b #
    .w x
end

#~# ORIGINAL

a b do
  c d do
    e #
      .f g
           .h
           .i
  end
end

#~# EXPECTED

a b do
  c d do
    e #
      .f g
           .h
           .i
  end
end

#~# ORIGINAL

context "b123" do
  it "d123" do
    expect_any_instance_of(Uploader::Null) # some comment
      .f123 g123(h123)
              .h123
              .i123
  end
end

#~# EXPECTED

context "b123" do
  it "d123" do
    expect_any_instance_of(Uploader::Null) # some comment
      .f123 g123(h123)
              .h123
              .i123
  end
end

#~# ORIGINAL bug_49

context "no sidecar/archive" do
  it "uploads destination master to the specified destination" do
    expect_any_instance_of(Uploader::Null) # rubocop:disable RSpec/AnyInstance
      .to receive(:upload)
            .with([file_path, "HON_TEST001_010.mxf"])
            .and_return(Uploader::Result.new(success: true))
  end
end

#~# EXPECTED

context "no sidecar/archive" do
  it "uploads destination master to the specified destination" do
    expect_any_instance_of(Uploader::Null) # rubocop:disable RSpec/AnyInstance
      .to receive(:upload)
            .with([file_path, "HON_TEST001_010.mxf"])
            .and_return(Uploader::Result.new(success: true))
  end
end
