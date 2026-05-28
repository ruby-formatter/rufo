# frozen_string_literal: true

require "prism"

class Rufo::PrismFormatter
  include Rufo::Settings

  INDENT_SIZE = 2

  # Prism reports some semantic-validity issues with :syntax level even
  # though it still builds a complete AST. The formatter can handle these
  # inputs (matching the existing Ripper-based formatter, which formats
  # syntactically-well-formed-but-semantically-invalid code).
  NON_FATAL_ERROR_TYPES = [
    :invalid_block_exit,            # redo / break / next outside a loop
    :invalid_retry_without_rescue,  # retry outside rescue
  ].freeze

  def self.format(code, **options)
    formatter = new(code, **options)
    formatter.format
    formatter.result
  end

  def initialize(code, **options)
    @code = code
    @parse_result = Prism.parse(code)
    fatal_errors = @parse_result.errors.reject { |e| NON_FATAL_ERROR_TYPES.include?(e.type) }
    unless fatal_errors.empty?
      error = fatal_errors.first
      raise Rufo::SyntaxError.new(error.message, error.location.start_line)
    end

    init_settings(options)
  end

  def format
    visitor = FormatVisitor.new(@code, @parse_result.comments)
    @parse_result.value.accept(visitor)
    visitor.finish
    @output = visitor.output

    @output.chomp! if @output.end_with?("\n\n")
    @output.lstrip!
    @output << "\n" unless @output.end_with?("\n")
  end

  def result
    @output
  end

  class FormatVisitor < Prism::Visitor
    attr_reader :output

    def initialize(code, comments)
      super()
      @code = code
      @output = +""
      @comments = comments
      @comment_index = 0
      @source_offset = 0
      @indent = 0
      @column = 0
      @indent_pending = true
      @pending_heredocs = []
    end

    def finish
      consume_source_up_to(@code.length)
      flush_pending_heredocs
    end

    def visit_nil_node(node)
      write_code_at(node.location)
    end

    def visit_true_node(node)
      write_code_at(node.location)
    end

    def visit_false_node(node)
      write_code_at(node.location)
    end

    def visit_integer_node(node)
      write_code_at(node.location)
    end

    def visit_float_node(node)
      write_code_at(node.location)
    end

    def visit_rational_node(node)
      write_code_at(node.location)
    end

    def visit_imaginary_node(node)
      write_code_at(node.location)
    end

    def visit_symbol_node(node)
      write_code_at(node.location)
    end

    def visit_interpolated_symbol_node(node)
      write_code_at(node.location)
    end

    def visit_string_node(node)
      if heredoc?(node)
        write_code_at(node.opening_loc)
        @pending_heredocs << node
        @source_offset = node.closing_loc.end_offset
      else
        write_code_at(node.location)
      end
    end

    def visit_class_variable_read_node(node)
      write_code_at(node.location)
    end

    def visit_global_variable_read_node(node)
      write_code_at(node.location)
    end

    def visit_numbered_reference_read_node(node)
      write_code_at(node.location)
    end

    def visit_local_variable_read_node(node)
      write_code_at(node.location)
    end

    def visit_local_variable_write_node(node)
      consume_source_up_to(node.location.start_offset)
      write(node.name.to_s)
      write(" = ")
      node.value.accept(self)
    end

    def visit_hash_node(node)
      write_code_at(node.location)
    end

    def visit_instance_variable_read_node(node)
      write_code_at(node.location)
    end

    def visit_undef_node(node)
      consume_source_up_to(node.location.start_offset)
      write("undef ")
      node.names.each_with_index do |name, i|
        if i > 0
          write(", ")
        end
        name.accept(self)
      end
    end

    def visit_redo_node(node)
      write_code_at(node.location)
    end

    def visit_retry_node(node)
      write_code_at(node.location)
    end

    def visit_alias_method_node(node)
      visit_alias(node)
    end

    def visit_alias_global_variable_node(node)
      visit_alias(node)
    end

    def visit_parentheses_node(node)
      write_code_at(node.opening_loc)
      node.body.accept(self)
      write_code_at(node.closing_loc)
    end

    def visit_call_node(node)
      if node.receiver && node.call_operator_loc
        node.receiver.accept(self)
        write_code_at(node.call_operator_loc)
        write_code_at(node.message_loc)
      elsif node.receiver
        # Unary prefix operator (e.g. -x, +x): message before receiver.
        write_code_at(node.message_loc)
        node.receiver.accept(self)
      else
        write_code_at(node.message_loc)
      end
    end

    def visit_if_node(node)
      consume_source_up_to(node.location.start_offset)
      write_code_at(node.if_keyword_loc)
      write(" ")
      node.predicate.accept(self)
      write_newline
      indent_by(Rufo::PrismFormatter::INDENT_SIZE) do
        node.statements&.accept(self)
      end
      write_newline_unless_pending
      write_code_at(node.end_keyword_loc)
    end

    def visit_unless_node(node)
      consume_source_up_to(node.location.start_offset)
      write_code_at(node.keyword_loc)
      write(" ")
      node.predicate.accept(self)
      write_newline
      indent_by(Rufo::PrismFormatter::INDENT_SIZE) do
        node.statements&.accept(self)
      end
      write_newline_unless_pending
      node.else_clause&.accept(self)
      write_code_at(node.end_keyword_loc)
    end

    def visit_else_node(node)
      write_code_at(node.else_keyword_loc)
      write_newline
      indent_by(Rufo::PrismFormatter::INDENT_SIZE) do
        node.statements&.accept(self)
      end
      write_newline_unless_pending
    end

    def visit_statements_node(node)
      node.body.each_with_index do |child, i|
        consume_source_up_to(child.location.start_offset)
        write_newline if i > 0 && !@indent_pending
        child.accept(self)
      end
    end

    private

    def visit_alias(node)
      consume_source_up_to(node.location.start_offset)
      write_code_at(node.keyword_loc)
      write(" ")
      node.new_name.accept(self)
      write(" ")
      node.old_name.accept(self)
    end

    # Append `value` to the output. Emits the pending indent first if we are
    # at the start of a line. `value` is assumed not to contain "\n" — use
    # `write_newline` to end a line.
    def write(value)
      return if value.empty?
      if @indent_pending
        pad = " " * @indent
        @output << pad
        @column += pad.length
        @indent_pending = false
      end
      @output << value
      @column += value.length
    end

    def write_newline
      @output << "\n"
      @column = 0
      @indent_pending = true
      flush_pending_heredocs
    end

    def write_newline_unless_pending
      write_newline unless @indent_pending
    end

    def write_code_at(location)
      consume_source_up_to(location.start_offset)
      write(@code[location.start_offset...location.end_offset])
      @source_offset = location.end_offset
    end

    def indent_by(amount)
      @indent += amount
      yield
    ensure
      @indent -= amount
    end

    def code_at(location)
      @code[location.start_offset...location.end_offset]
    end

    # Drain comments that occur before `offset` and advance the source cursor.
    # `@source_offset` is the position past the last source bytes already
    # accounted for in `@output` (either copied verbatim, or skipped as
    # discardable whitespace between AST nodes).
    def consume_source_up_to(offset)
      return if offset <= @source_offset
      while @comment_index < @comments.size && @comments[@comment_index].location.start_offset < offset
        emit_comment(@comments[@comment_index])
        @comment_index += 1
      end
      @source_offset = offset if offset > @source_offset
    end

    def heredoc?(node)
      node.opening_loc&.slice&.start_with?("<<")
    end

    # Append the body and closing of pending heredocs after the current
    # output line. Prism keeps the opening, body, and closing in separate
    # source locations because they are interleaved with whatever follows the
    # opening on the same source line.
    def flush_pending_heredocs
      return if @pending_heredocs.empty?
      @output << "\n" unless @output.empty? || @output.end_with?("\n")
      heredocs = @pending_heredocs
      @pending_heredocs = []
      heredocs.each do |heredoc|
        @output << @code[heredoc.content_loc.start_offset...heredoc.content_loc.end_offset]
        @output << @code[heredoc.closing_loc.start_offset...heredoc.closing_loc.end_offset]
      end
      @column = 0
      @indent_pending = true
    end

    def emit_comment(comment)
      line_start = @code.rindex("\n", comment.location.start_offset - 1)
      line_start = line_start ? line_start + 1 : 0
      before_on_line = @code[line_start...comment.location.start_offset]

      if before_on_line.match?(/\A\s*\z/)
        # Standalone comment — emit on its own line.
        write_newline_unless_pending
        write(comment.slice)
        write_newline
      else
        # Trailing comment — preserve the spacing between the preceding code
        # and the comment as it appears in the source.
        gap_start = [@source_offset, line_start].max
        write(@code[gap_start...comment.location.start_offset])
        write(comment.slice)
        write_newline
      end
      @source_offset = comment.location.end_offset
    end
  end
end
