require "ripper"
require "awesome_print"

module Rufa
  class Formatter
    def self.format(code, **options)
      Printer.new(new(code).format).print
    end

    def self.debug(code, **options)
      Printer.new(new(code).format).debug
    end

    def initialize(code)
      @tokens = Ripper.lex(code).map { |t| Token.new t }
      @sexp = Ripper.sexp(code)
      @output = []
      @current_location = [0, 0]

      if sexp.nil?
        fail "Syntax error!"
      end
    end

    def format
      parse(sexp)
    end

    private

    attr_reader :tokens, :output, :sexp

    def parse(element)
      case element[0]
      when :program
        # [:program, [body]]
        element[1].map { |e| Statement.new(*parse(e)) }
      when :bodystmt
        element[1].map { |e| Statement.new(*parse(e)) }
      when :assign
        # [:assign, [:var_field, [:@ident]]]
        handle_assign(element[1], element[2])
      when :def
        # [:def, [:@ident, [:paren, [:params]], :bodystmt]]
        handle_def(element[1], parse(element[2]), element[3])
      when :string_literal
        Group.new(parse(element[1]))
      when :string_content
        parse(element[1])
      when :@tstring_content
        "'" + element[1] + "'"
      when :void_stmt
        nil
      when :var_ref
        element[1][1]
      when :paren
        # [:paren, body]
        parse(element[1])
      when :params
        # [:params, [normal_args]]
        handle_params(*element[1..-1])
      else
        ap element
        fail "formatter does not know how to handle #{element.ai}"
      end
    end

    def handle_params(normal_args, *other_args)
      if normal_args
        _normal_args = normal_args.map { |a| [Identifier.new(a).label, ",", :line] }.flatten[0..-3]
        ["(", :softline, :indent, *_normal_args, ")"]
      end
    end

    def handle_assign(identifier, value)
      Group.new(identifier[1][1], " =", :line, :indent, parse(value))
    end

    def handle_def(identifier, params, body)
      identifier = Identifier.new(identifier)

      MethodDefinition.new(
        Group.new("def #{identifier.label}", *params),
        :hardline,
        :indent,
        parse(body),
        "end",
      )
    end

    class Identifier
      def initialize(sexp)
        @label = sexp[1]
      end

      attr_reader :label
    end

    class Params
      def initialize(sexp)
        @params = sexp[1..-1]
      end

      attr_reader :params
    end

    class Body
      def initialize(sexp)
        @body = sexp[1]
      end

      attr_reader :body
    end

    def process(token)
      case token.type
      when :on_ident
        output << token.label
      end
    end
  end

  class Group
    def initialize(*elements)
      @elements = elements
    end

    attr_reader :elements
  end

  class Statement
    def initialize(*elements)
      @elements = elements
    end

    attr_reader :elements
  end

  class MethodDefinition < Statement; end

  class Token
    def initialize(token)
      @location = token[0]
      @type = token[1]
      @label = token[2]
    end

    attr_reader :location, :type, :label
  end

  class Printer
    def initialize(output)
      @output = output
    end

    ALLOWED_LENGTH = 80

    def print
      puts debug
      output.map { |group| group_to_string(group, indent: 0) }.join("\n")
    end

    def debug
      output.ai(raw: true, index: false)
    end

    private

    def group_to_string(group, indent:)
      # if on_one_line(group, indent: indent).length <= ALLOWED_LENGTH
      #   on_one_line(group, indent: indent)
      # else
      #   with_broken_lines(group, indent: indent)
      # end

      with_broken_lines(group, indent: indent)
    end

    def on_one_line(group, indent:)
      output = []
      elements = group.elements.dup

      while elements.any?
        element = elements.shift

        case element
        when :line
          output << " "
        when :hardline
          output << "\n"
          indent += 1
        when :softline
          next if elements.first.to_s.empty?

          output << " "
        when Group
          output << group_to_string(element, indent: indent) + "\n"
        else
          output << element
        end
      end

      output.join("")
    end
      
    def with_broken_lines(group, indent:)
      output = ""
      elements = group.elements.dup
      child_indent = 0

      indent_string = -> { "  " * (indent + child_indent) }

      while element = elements.shift
        case element
        when MethodDefinition
          string = group_to_string(element, indent: (indent + child_indent))

          if elements.first.is_a?(Statement)
            output << string + "\n\n" + indent_string.call
          else
            output << string
          end
        when Statement
          string = group_to_string(element, indent: (indent + child_indent))

          if elements.first.is_a?(Statement)
            output << string + "\n" + indent_string.call
          else
            output << string
          end
        when :line, :softline, :hardline
          output << "\n"
          if elements.first != :indent
            output << indent_string.call
          end
        when :indent
          child_indent += 1
          output << indent_string.call
        when Group
          output << group_to_string(element, indent: indent + child_indent)
        when Array
          elements.unshift(*element)
        when String
          if elements.first.nil? && child_indent > 0
            child_indent -= 1
            output << "\n" + indent_string.call + element
          else
            output << element
          end
        else
          ap element
          fail "printer tried to print unknown element: #{element.ai}"
        end
      end

      output
    end

    private


    attr_reader :output
  end
end
