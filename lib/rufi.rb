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
      StringifyLex.call SexpParser.call(sexp).to_lex
    end

    def debug
      SexpParser.call(sexp).to_lex.ai index: false
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

      (element.column - output.last.length).times do
        output.last << " "
      end

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

    def parse_elements(elements)
      elements.map { |e| SexpParser.call(e) }
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

  HARDLINE = :hardline
  INDENT = :indent
  DEDENT = :dedent

  TokensToLex = lambda do |tokens|
    line = 0
    line_column = 0
    indent_column = 0
    lex_elements = []
    tokens = tokens.dup

    while token = tokens.shift
      case token
      when Token
        lex_elements << LexElement.new(line, line_column, token.label)
        line_column += token.label.length
      when HARDLINE
        line += 1
        line_column = indent_column
      when INDENT
        indent_column += 2
        line_column += 2
      when DEDENT
        line_column -= 2
        indent_column -= 2
      else
        fail "don't know what to do with #{token}"
      end
    end

    lex_elements
  end

  class Program < Node
    def parse_elements(elements)
      elements.first.map { |e| Statement.new(e) }
    end

    def to_lex
      TokensToLex.call FlattenTokens.call(token_tree)
    end
  end

  class Statement < Node
    def token_tree
      [
        super,
        HARDLINE,
      ]
    end
  end

  class StringLiteral < Node
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
    def token_tree
      t = super
      t.insert(1, Token.new(" = "))
      t
    end
  end

  class VarField < Node
  end

  class MethodDefinition < Node
    def token_tree
      tokens = super

      [
        Token.new("def "),
        tokens[0..-2],
        HARDLINE,
        INDENT,
        tokens.last,
        HARDLINE,
        DEDENT,
        Token.new("end"),
      ]
    end
  end

  Intersperse = lambda do |array, element|
    array.map { |e| [e, element] }.flatten(1)[0..-2]
  end

  class Params < Node
    def parse_elements(elements)
      return [] unless elements.first

      elements.first.map { |e| SexpParser.call(e) }
    end

    def token_tree
      return [] if super.empty?

      [
        Token.new("("),
        Intersperse.call(super, Token.new(", ")),
        Token.new(")"),
      ]
    end
  end

  class BodyStatement < Node
    def parse_elements(elements)
      elements.first.map { |e| SexpParser.call(e) }
    end

    def token_tree
      e = elements.dup

      tokens = []

      while element = e.shift
        tokens << element.token_tree

        case e.first
        when MethodDefinition
          tokens << [HARDLINE, HARDLINE]
        when nil
        else
          tokens << HARDLINE
        end
      end

      tokens
    end
  end

  class Paren < Node
  end

  class VarRef < Node
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
    def: MethodDefinition,
    params: Params,
    bodystmt: BodyStatement,
    paren: Paren,
    var_ref: VarRef,
  }

  SexpParser = lambda do |sexp|
    type, *rest = sexp

    TYPE_MAP.fetch(type).new(*rest)
  end
end
