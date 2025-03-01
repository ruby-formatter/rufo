# frozen_string_literal: true

require "prism"

class Rufo::PrismFormatter
  include Rufo::Settings

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
    visitor = FormatVisitor.new(@code)
    @parse_result.value.accept(visitor)
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

    def initialize(code)
      super()
      @code = code
      @output = +""
    end

    def visit_nil_node(_node)
      write("nil")
    end

    def visit_true_node(_node)
      write("true")
    end

    def visit_false_node(_node)
      write("false")
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

    def visit_local_variable_write_node(node)
      write(node.name.to_s)
      write(" = ")
      node.value.accept(self)
    end

    def visit_hash_node(node)
      write_code_at(node.location)
    end

    private

    def write(value)
      @output << value
    end

    def write_code_at(location)
      write(code_at(location))
    end

    def code_at(location)
      @code[location.start_offset...location.end_offset]
    end
  end
end
