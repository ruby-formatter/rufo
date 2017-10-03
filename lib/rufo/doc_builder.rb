module Rufo
  class DocBuilder
    class InvalidDocError < StandardError; end

    class << self

      # Combine an array of items into a single string.
      def concat(parts)
        assert_docs(parts)
        {
          type: :concat, parts: parts,
        }
      end

      # Increase level of indentation.
      def indent(contents)
        assert_doc(contents)
        {
          type: :indent, contents: contents,
        }
      end

      # Increase indentation by a fixed number.
      def align(n, contents)
        assert_doc(contents)
        {type: :align, contents: contents, n: n}
      end

      # Groups are items that the printer should try and fit onto a single line.
      # If the group does not fit then it breaks instead.
      def group(contents, opts = {})
        assert_doc(contents)
        {
          type: :group,
          contents: contents,
          break: !!opts[:should_break],
          expanded_states: opts[:expanded_states],
        }
      end

      # Rather than breaking if the items do not fit this tries a different set
      # of items.
      def conditional_group(states, opts = {})
        group(states.first, opts.merge(expanded_states: states))
      end

      # Alternative to group. This only breaks the required items rather then
      # all items if they do not fit.
      def fill(parts)
        assert_docs(parts)

        {type: :fill, parts: parts}
      end

      # Print first arg if the group breaks otherwise print the second.
      def if_break(break_contents, flat_contents)
        assert_doc(break_contents) unless break_contents.nil?
        assert_doc(flat_contents) unless flat_contents.nil?

        {type: :if_break, break_contents: break_contents, flat_contents: flat_contents}
      end

      # Append content to the end of a line. This gets placed just before a new line.
      def line_suffix(contents)
        assert_doc(contents)
        {type: :line_suffix, contents: contents}
      end

      # Join list of items with a separator.
      def join(sep, arr)
        result = []
        arr.each_with_index do |element, index|
          unless index == 0
            result << sep
          end
          result << element
        end
        concat(result)
      end

      def add_alignment_to_doc(doc, size, tab_width)
        return doc unless size > 0
        (size/tab_width).times { doc = indent(doc) }
        doc = align(size % tab_width, doc)
        align(-Float::INFINITY, doc)
      end

      private

      def assert_docs(parts)
        parts.each(&method(:assert_doc))
      end

      def assert_doc(val)
        unless val.is_a?(String) || (val.is_a?(Hash) && val[:type].is_a?(Symbol))
          raise InvalidDocError.new("Value #{val.inspect} is not a valid document")
        end
      end
    end

    # Use this to ensure that line suffixes do not move to the last line in group.
    LINE_SUFFIX_BOUNDARY = {type: :line_suffix_boundary}
    # Use this to force the parent to break
    BREAK_PARENT = {type: :break_parent}
    # If the content fits on one line the newline will be replaced with a space.
    # Newlines are what triggers indentation to be added.
    LINE = {type: :line}
    # If the content fits on one line the newline will be replaced by nothing.
    SOFT_LINE = {type: :line, soft: true}
    # This newline is always included regardless of if the content fits on one
    # line or not.
    HARD_LINE = concat([{type: :line, hard: true}, BREAK_PARENT])
    # This is a newline that is always included and does not cause the
    # indentation to change subsequently.
    LITERAL_LINE = concat([
      {type: :line, hard: true, literal: true},
      BREAK_PARENT,
    ])

    # This keeps track of the cursor in the document.
    CURSOR = {type: :cursor, placeholder: :cursor}
  end
end
