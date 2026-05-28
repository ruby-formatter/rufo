# frozen_string_literal: true

require "prism"

class Rufo::PrismFormatter
  include Rufo::Settings

  DEBUG = !ENV["RUFO_PRISM_DEBUG"].to_s.empty?

  def self.format(code, **options)
    formatter = new(code, **options)
    formatter.format
    formatter.result
  end

  def initialize(code, **options)
    @code = code
    @parse_result = Prism.parse(code)
    unless @parse_result.errors.empty?
      error = @parse_result.errors.first
      raise Rufo::SyntaxError.new(error.message, error.location.start_line)
    end

    init_settings(options)
  end

  def format
    debug_log @parse_result
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

  def debug_log(object)
    if DEBUG
      p [:debug, object]
    end
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
    end

    def finish
      consume_source_up_to(@code.length)
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
      write_code_at(node.location)
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
          write ", "
        end
        name.accept(self)
      end
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

    def visit_statements_node(node)
      previous = nil
      node.body.each do |child|
        consume_source_up_to(child.location.start_offset)
        if previous && !@output.end_with?("\n")
          write "\n"
        end

        child.accept(self)
        previous = child
      end
    end

    private

    def write(value)
      @output << value
    end

    def write_code_at(location)
      consume_source_up_to(location.start_offset)
      @output << @code[location.start_offset...location.end_offset]
      @source_offset = location.end_offset
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

    def emit_comment(comment)
      line_start = @code.rindex("\n", comment.location.start_offset - 1)
      line_start = line_start ? line_start + 1 : 0
      before_on_line = @code[line_start...comment.location.start_offset]

      if before_on_line.match?(/\A\s*\z/)
        # Standalone comment — emit on its own line.
        @output << "\n" unless @output.empty? || @output.end_with?("\n")
        @output << comment.slice
        @output << "\n"
      else
        # Trailing comment — preserve the spacing between the preceding code
        # and the comment as it appears in the source.
        gap_start = [@source_offset, line_start].max
        @output << @code[gap_start...comment.location.start_offset]
        @output << comment.slice
        @output << "\n"
      end
      @source_offset = comment.location.end_offset
    end

    def debug_log(object)
      if Rufo::PrismFormatter::DEBUG
        p [:debug, object]
      end
    end
  end
end
