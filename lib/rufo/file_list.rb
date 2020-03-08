# frozen_string_literal: true

# This file is based on https://github.com/ruby/rake/blob/master/lib/rake/file_list.rb
# Git commit: 5b8f8fc41a5d7d7d6a5d767e48464c60884d3aee

module Rufo

  ##
  # A FileList is essentially an array with a few helper methods defined to
  # make file manipulation a bit easier.
  #
  # FileLists are lazy.  When given a list of glob patterns for possible files
  # to be included in the file list, instead of searching the file structures
  # to find the files, a FileList holds the pattern for latter use.
  #
  # This allows us to define a number of FileList to match any number of
  # files, but only search out the actual files when then FileList itself is
  # actually used.  The key is that the first time an element of the
  # FileList/Array is requested, the pending patterns are resolved into a real
  # list of file names.
  #
  class FileList

    # == Method Delegation
    #
    # The lazy evaluation magic of FileLists happens by implementing all the
    # array specific methods to call +resolve+ before delegating the heavy
    # lifting to an embedded array object (@items).
    #
    # In addition, there are two kinds of delegation calls.  The regular kind
    # delegates to the @items array and returns the result directly.  Well,
    # almost directly.  It checks if the returned value is the @items object
    # itself, and if so will return the FileList object instead.
    #
    # The second kind of delegation call is used in methods that normally
    # return a new Array object.  We want to capture the return value of these
    # methods and wrap them in a new FileList object.  We enumerate these
    # methods in the +SPECIAL_RETURN+ list below.

    # List of array methods (that are not in +Object+) that need to be
    # delegated.
    ARRAY_METHODS = (Array.instance_methods - Object.instance_methods).map(&:to_s)

    # List of additional methods that must be delegated.
    MUST_DEFINE = %w[inspect <=>]

    # List of methods that should not be delegated here (we define special
    # versions of them explicitly below).
    MUST_NOT_DEFINE = %w[to_a to_ary partition * <<]

    # List of delegated methods that return new array values which need
    # wrapping.
    SPECIAL_RETURN = %w[
      map collect sort sort_by select find_all reject grep
      compact flatten uniq values_at
      + - & |
    ]

    DELEGATING_METHODS = (ARRAY_METHODS + MUST_DEFINE - MUST_NOT_DEFINE).map(&:to_s).sort.uniq

    # Now do the delegation.
    DELEGATING_METHODS.each do |sym|
      if SPECIAL_RETURN.include?(sym)
        ln = __LINE__ + 1
        class_eval %{
          def #{sym}(*args, &block)
            resolve
            result = @items.send(:#{sym}, *args, &block)
            self.class.new.import(result)
          end
        }, __FILE__, ln
      else
        ln = __LINE__ + 1
        class_eval %{
          def #{sym}(*args, &block)
            resolve
            result = @items.send(:#{sym}, *args, &block)
            result.object_id == @items.object_id ? self : result
          end
        }, __FILE__, ln
      end
    end

    GLOB_PATTERN = %r{[*?\[\{]}

    # Create a file list from the globbable patterns given.  If you wish to
    # perform multiple includes or excludes at object build time, use the
    # "yield self" pattern.
    #
    # Example:
    #   file_list = FileList.new('lib/**/*.rb', 'test/test*.rb')
    #
    #   pkg_files = FileList.new('lib/**/*') do |fl|
    #     fl.exclude(/\bCVS\b/)
    #   end
    #
    def initialize(*patterns)
      @pending_add = []
      @pending = false
      @exclude_patterns = DEFAULT_IGNORE_PATTERNS.dup
      @exclude_procs = DEFAULT_IGNORE_PROCS.dup
      @items = []
      patterns.each { |pattern| include(pattern) }
      yield self if block_given?
    end

    # Add file names defined by glob patterns to the file list.  If an array
    # is given, add each element of the array.
    #
    # Example:
    #   file_list.include("*.java", "*.cfg")
    #   file_list.include %w( math.c lib.h *.o )
    #
    def include(*filenames)
      filenames.each do |fn|
        @pending_add << fn
      end
      @pending = true
      self
    end

    alias :add :include

    # Register a list of file name patterns that should be excluded from the
    # list.  Patterns may be regular expressions, glob patterns or regular
    # strings.  In addition, a block given to exclude will remove entries that
    # return true when given to the block.
    #
    # Note that glob patterns are expanded against the file system. If a file
    # is explicitly added to a file list, but does not exist in the file
    # system, then an glob pattern in the exclude list will not exclude the
    # file.
    #
    # Examples:
    #   FileList['a.c', 'b.c'].exclude("a.c") => ['b.c']
    #   FileList['a.c', 'b.c'].exclude(/^a/)  => ['b.c']
    #
    # If "a.c" is a file, then ...
    #   FileList['a.c', 'b.c'].exclude("a.*") => ['b.c']
    #
    # If "a.c" is not a file, then ...
    #   FileList['a.c', 'b.c'].exclude("a.*") => ['a.c', 'b.c']
    #
    def exclude(*patterns, &block)
      patterns.each do |pat|
        @exclude_patterns << pat
      end
      @exclude_procs << block if block_given?
      resolve_exclude unless @pending
      self
    end

    # Return the internal array object.
    def to_a
      resolve
      @items
    end

    def <<(obj)
      resolve
      @items << obj
      self
    end

    # Resolve all the pending adds now.
    def resolve
      if @pending
        @pending = false
        @pending_add.each do |fn| resolve_add(fn) end
        @pending_add = []
        resolve_exclude
      end
      self
    end

    def resolve_add(filename) # :nodoc:
      case filename
      when GLOB_PATTERN
        add_matching(filename)
      else
        self << filename
      end
    end

    private :resolve_add

    def resolve_exclude # :nodoc:
      reject! { |fn| excluded_from_list?(fn) }
      self
    end

    private :resolve_exclude
    # Convert a FileList to a string by joining all elements with a space.
    def to_s
      resolve
      self.join(" ")
    end

    # Add matching glob patterns.
    def add_matching(pattern)
      self.class.glob(pattern).each do |fn|
        self << fn unless excluded_from_list?(fn)
      end
    end

    private :add_matching

    # Should the given file name be excluded from the list?
    def excluded_from_list?(filename)
      return true if @exclude_patterns.any? do |pat|
        case pat
        when Regexp
          filename =~ pat
        when GLOB_PATTERN
          flags = File::FNM_PATHNAME
          flags |= File::FNM_EXTGLOB
          File.fnmatch?(pat, filename, flags)
        else
          filename == pat
        end
      end
      @exclude_procs.any? { |p| p.call(filename) }
    end

    DEFAULT_IGNORE_PATTERNS = [
      /(^|[\/\\])CVS([\/\\]|$)/,
      /(^|[\/\\])\.svn([\/\\]|$)/,
      /\.bak$/,
      /~$/,
    ]
    DEFAULT_IGNORE_PROCS = [
      proc { |fn| fn =~ /(^|[\/\\])core$/ && !File.directory?(fn) },
    ]

    class << self
      # Get a sorted list of files matching the pattern. This method
      # should be preferred to Dir[pattern] and Dir.glob(pattern) because
      # the files returned are guaranteed to be sorted.
      def glob(pattern, *args)
        Dir.glob(pattern, *args).sort
      end
    end
  end
end
