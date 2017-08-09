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
      StringifyLex.call SexpParser.call(sexp).to_lex(0, 0)
    end

    def debug
      SexpParser.call(sexp).to_lex(0, 0).ai index: false
    end

    attr_reader :sexp
  end

  StringifyLex = lambda do |lex_elements|
    line = lex_elements.first.line
    # column = lex_elements.first.column
    elements = lex_elements.dup
    output = [""]

    while element = elements.shift
      (element.line - line).times do
        output << ""
      end

      line = element.line

      output.last << element.label
    end

    output.join("\n")
  end

  FlattenTokens = lambda do |tokens|
    t = tokens.dup
    elements = []

    while token = t.shift
      if token.is_a?(Array)
        t.unshift(*token)
      else
        elements << token
      end
    end

    elements
  end

  class Node
    def initialize(*elements)
      @elements = parse_elements(elements)
    end

    def token_tree
      elements.map(&:token_tree)
    end
    
    attr_reader :elements, :parsed
  end

  class Token
    def initialize(label)
      @label = label
    end

    attr_reader :label
    attr_accessor :wants_newline
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

    def to_lex(line, original_column)
      column = original_column
      last_line_column = column

      FlattenTokens.call(token_tree).map do |token|
        LexElement.new(line, column, token.label).tap do
          if token.wants_newline
            line += 1
            column = last_line_column
          else
            column += token.label.length
          end
        end
      end
    end
  end

  class Statement < Node
    def parse_elements(elements)
      elements.map { |e| SexpParser.call(e) }
    end

    def token_tree
      t = FlattenTokens.call super
      t.last.wants_newline = true
      t
    end
  end

  class StringLiteral < Node
    def parse_elements(elements)
      elements.map { |e| SexpParser.call(e) }
    end

    def token_tree
      quote_character = elements.first.quote_character

      [
        Token.new(quote_character),
        super,
        Token.new(quote_character),
      ]
    end
  end

  class StringContent < Node
    def parse_elements(elements)
      elements.map { |e| SexpParser.call(e) }
    end

    def quote_character
      if elements.all? { |e| e.is_a? TStringContent }
        "'"
      else
        '"'
      end
    end
  end

  class TStringContent < NodeWithLocation
    def parse_elements(elements)
      elements
    end

    def token_tree
      Token.new(elements.first)
    end
  end

  class StringEmbeddedExpression < Node
    def parse_elements(elements)
      elements.first.map { |e| SexpParser.call(e) }
    end

    def token_tree
      [
        Token.new('#{'),
        super,
        Token.new('}'),
      ]
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

    def token_tree
      Token.new(elements.first)
    end
  end

  class Assign < Node
    def parse_elements(elements)
      elements.map { |e| SexpParser.call(e) }
    end

    def token_tree
      t = super
      t.insert(1, Token.new(" = "))
      t
    end
  end

  class VarField < Node
    def parse_elements(elements)
      elements.map { |e| SexpParser.call(e) }
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
    assign: Assign,
    var_field: VarField,
  }

  SexpParser = lambda do |sexp|
    type, *rest = sexp

    TYPE_MAP.fetch(type).new(*rest)
  end
end
