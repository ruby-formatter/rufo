require "ripper"
require "awesome_print"

module Rufi
  class Formatter
    def self.format(code, **options)
      # Printer.new(new(code).format).print
      new(code).format
    end

    def self.debug(code, **options)
      new(code).debug
    end

    def initialize(code)
      # @tokens = Ripper.lex(code).map { |t| Token.new t }
      @sexp = Ripper.sexp(code)
      @output = []

      if sexp.nil?
        fail "Syntax error!"
      end
    end

    def format
      StringifyTokens.call SexpParser.call(sexp).to_lex(0, 0)
    end

    def debug
      SexpParser.call(sexp).ai index: false, raw: true
    end

    attr_reader :sexp
  end

  StringifyTokens = lambda do |maybe_token|
    if maybe_token.is_a? Token
      ap maybe_token
      maybe_token.label
    else
      maybe_token.map { |t| StringifyTokens.call(t) }.join("")
    end
  end

  class Node
    def initialize(*elements)
      @elements = parse_elements(elements)
    end

    def to_lex(line, column)
      tokens.map do |token|
        LexElement.new(line, column, token.label).tap do
          column += token.label.length
        end
      end
    end

    attr_reader :elements, :parsed
  end

  class Token
    def initialize(label)
      @label = label
    end

    attr_reader :label
  end

  class LexElement
    def initialize(line, column, label)
      @line = line
      @column = column
      @label = label
    end

    attr_reader :line, :column, :label
  end

  class NodeWithLocation < Node
    def initialize(*elements, location)
      super(*elements)
      @location = location
    end

    attr_reader :location
  end

  class Program < Node
    def parse_elements(elements)
      elements.first.map { |e| Statement.new(e) }
    end
  end

  class Statement < Node
    def parse_elements(elements)
      elements.map { |e| SexpParser.call(e) }
    end
  end

  class StringLiteral < Node
    def parse_elements(elements)
      elements.map { |e| SexpParser.call(e) }
    end

    def token_elements
      [
        Token.new('"'),
        elements.map { |e| e.to_token(line, column) },
        Token.new('"'),
      ]
    end
  end

  class StringContent < Node
    def parse_elements(elements)
      elements.map { |e| SexpParser.call(e) }
    end
  end

  class TStringContent < NodeWithLocation
    def parse_elements(elements)
      elements
    end

    def to_token(line, column)
      Token.new(line, column, elements.first)
    end
  end

  class StringEmbeddedExpression < Node
    def parse_elements(elements)
      elements.first.map { |e| SexpParser.call(e) }
    end

    def to_token(line, column)
      [
        Token.new
      elements.map do |element|
        token = element.to_token(line, column)

        if token.is_a?(Token)
          column += token.label.length
        end

        token
      end
      # [
      #   Token.new(line, column, '#{'),
      #   elements.map { |e| e.to_token(line, column + 2) },
      #   Token.new(line, column, '}'),
      # ]
    end
  end

  class VariableCall < Node
    def parse_elements(elements)
      elements.map { |e| SexpParser.call(e) }
    end
  end

  class Identifier < NodeWithLocation
    def parse_elements(elements)
      elements
    end

    def to_token(line, column)
      Token.new(line, column, elements.first)
    end
  end

  TYPE_MAP = {
    program: Program,
    string_literal: StringLiteral,
    string_content: StringContent,
    :@tstring_content => TStringContent,
    string_embexpr: StringEmbeddedExpression,
    vcall: VariableCall,
    :@ident => Identifier,
  }

  SexpParser = lambda do |sexp|
    type, *rest = sexp

    TYPE_MAP.fetch(type).new(*rest)
  end
end

#     private

#     attr_reader :output, :sexp

#     def parse(element)
#       case element[0]
#       when :program
#         Program.new(element)
#         # [:program, [body]]
#         element[1].map { |e| Statement.new(*parse(e)) }
#       when :bodystmt
#         element[1].map { |e| Statement.new(*parse(e)) }
#       when :assign
#         # [:assign, [:var_field, [:@ident]]]
#         handle_assign(element[1], element[2])
#       when :def
#         # [:def, [:@ident, [:paren, [:params]], :bodystmt]]
#         handle_def(element[1], parse(element[2]), element[3])
#       when :string_literal
#         Group.new(parse(element[1]))
#       when :string_content
#         parse(element[1])
#       when :@tstring_content
#         "'" + element[1] + "'"
#       when :void_stmt
#         nil
#       when :var_ref
#         element[1][1]
#       when :paren
#         # [:paren, body]
#         parse(element[1])
#       when :params
#         # [:params, [normal_args]]
#         handle_params(*element[1..-1])
#       else
#         ap element
#         fail "formatter does not know how to handle #{element.ai}"
#       end
#     end

#     def handle_params(normal_args, *other_args)
#       if normal_args
#         _normal_args = normal_args.map { |a| [Identifier.new(a).label, ",", :line] }.flatten[0..-3]
#         ["(", :softline, :indent, *_normal_args, ")"]
#       end
#     end

#     def handle_assign(identifier, value)
#       Group.new(identifier[1][1], " =", :line, :indent, parse(value))
#     end

#     def handle_def(identifier, params, body)
#       identifier = Identifier.new(identifier)

#       MethodDefinition.new(
#         Group.new("def #{identifier.label}", *params),
#         :hardline,
#         :indent,
#         parse(body),
#         "end",
#       )
#     end

#     class Identifier
#       def initialize(sexp)
#         @label = sexp[1]
#       end

#       attr_reader :label
#     end

#     class Params
#       def initialize(sexp)
#         @params = sexp[1..-1]
#       end

#       attr_reader :params
#     end

#     class Body
#       def initialize(sexp)
#         @body = sexp[1]
#       end

#       attr_reader :body
#     end
#   end

#   class Group
#     def initialize(*elements)
#       @elements = elements
#     end

#     attr_reader :elements
#   end

#   class Statement
#     def initialize(*elements)
#       @elements = elements
#     end

#     attr_reader :elements
#   end

#   class MethodDefinition < Statement; end
# end
