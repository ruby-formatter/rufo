require "ripper"
require "awesome_print"
require "pry"

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

  ALLOWED_LENGTH = 80

  StringifyLex = lambda do |lex_elements|
    line = lex_elements.first.line
    column = 0
    elements = lex_elements.dup
    output = [""]

    while element = elements.shift
      (element.line - line).times do
        output << ""
        column = 0
      end

      (element.column - column).times do
        output.last << " "
      end

      column = element.column + element.label.length
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
    def initialize(*elements, parent:)
      @parent = parent
      # TODO: remove this. it's helpful for debugging
      @elements = elements
      @elements = parse_elements(elements)
    end

    def parse_elements(elements)
      elements.map { |e| SexpParser.call(e, parent: self) }
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

  class Group
    def initialize(*tokens)
      @tokens = FlattenTokens.call(tokens)
    end

    attr_reader :tokens
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
    def initialize(*elements, location, parent:)
      super(*elements, parent: parent)
      @location = location
    end

    attr_reader :location
  end

  HARDLINE = :hardline
  SOFTLINE = :softline
  INDENT = :indent
  DEDENT = :dedent
  LINE = :line

  GroupToLex = lambda do |group|
    GroupToLexHash.call(group)[:lex_elements]
  end

  class GroupToLexHash
    def self.call(*args)
      new(*args).call
    end

    def initialize(group, line: 0, line_column: 0, indent_column: 0)
      @tokens = group.tokens.clone
      @needs_break = false
      @initial_line = line
      @initial_line_column = line_column
      @initial_indent_column = indent_column
    end

    def call
      output = format

      if output == :needs_break
        self.needs_break = true
        format
      else
        output
      end
    end

    private

    attr_accessor :needs_break

    def format
      lex_elements = []
      tokens = @tokens.clone
      line = @initial_line
      line_column = @initial_line_column
      indent_column = @initial_indent_column

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
        when DEDENT
          indent_column -= 2
          line_column -= 2
        when LINE
          if needs_break
            line += 1
            line_column = indent_column
          else
            line_column += 1
          end
        when SOFTLINE
          if needs_break
            line += 1
            line_column = indent_column
          end
        when Group
          lex_hash = GroupToLexHash.call(token, line: line, line_column: line_column, indent_column: indent_column)

          line = lex_hash[:line]
          line_column = lex_hash[:line_column]
          indent_column = lex_hash[:indent_column]
          lex_elements.push(*lex_hash[:lex_elements])

          if lex_hash[:needs_break] && !needs_break
            return :needs_break
          end
        else
          fail "don't know what to do with #{token}"
        end

        if line_column > ALLOWED_LENGTH && !needs_break
          return :needs_break
        end
      end

      {
        line: line,
        line_column: line_column,
        indent_column: indent_column,
        lex_elements: lex_elements,
        needs_break: needs_break,
      }
    end
  end

  class Program < Node
    def parse_elements(elements)
      elements.first.map { |e| Statement.new(e, parent: self) }
    end

    def to_lex
      # TokensToLex.call FlattenTokens.call(token_tree)
      GroupToLex.call(group)
    end

    def group
      Group.new(token_tree)
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
      if elements.any? { |e| !e.is_a? TStringContent }
        '"'
      elsif elements.map(&:elements).join("").include?("'")
        '"'
      else
        "'"
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
      elements.first.map { |e| SexpParser.call(e, parent: self) }
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

  class ConstantNode < Identifier
  end

  class Assign < Node
    def token_tree
      fail "i dont know how to assign" if elements.length > 2

      key = elements.first
      value = elements.last

      case value
      when StringLiteral
        Group.new(key.token_tree, Token.new(" ="), INDENT, LINE, value.token_tree, DEDENT)
      else
        Group.new(key.token_tree, Token.new(" = "), value.token_tree)
      end
    end
  end

  class VarField < Node
  end

  class MethodDefinition < Node
    def token_tree
      tokens = super

      if elements.last.elements.all? { |e| e.is_a? VoidStatement }
        Group.new(
          Token.new("def "),
          tokens[0..-2],
          Token.new("; end")
        )
      else
        [
          Group.new(
            Token.new("def "),
            tokens[0..-2],
          ),
          INDENT,
          HARDLINE,
          tokens.last,
          DEDENT,
          HARDLINE,
          Token.new("end"),
        ]
      end
    end
  end

  Intersperse = lambda do |array, element|
    array.map { |e| [e, element] }.flatten(1)[0..-2]
  end

  class Params < Node
    def parse_elements(elements)
      return [] unless elements.first

      elements.first.map { |e| SexpParser.call(e, parent: self) }
    end

    def token_tree
      return [] if super.empty?

      [
        Token.new("("),
        INDENT,
        SOFTLINE,
        Intersperse.call(super, [Token.new(","), LINE]),
        DEDENT,
        SOFTLINE,
        Token.new(")"),
      ]
    end
  end

  class BodyStatement < Node
    def parse_elements(elements)
      # return [] if elements.empty?

      (elements.first + [elements[1]]).compact.map { |e| SexpParser.call(e, parent: self) }
    # rescue => e
    #   fail e.message + "\n\n" + self.ai(index: false,raw: true) 
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

  class IntegerNode < NodeWithLocation
    def parse_elements(elements)
      elements
    end

    def token_tree
      Token.new(elements.first)
    end
  end

  class FloatNode < NodeWithLocation
    def parse_elements(elements)
      elements
    end

    def token_tree
      Token.new(elements.first)
    end
  end

  class ArrayNode < Node
    def parse_elements(elements)
      return [] if elements.first.nil?

      elements.first.map { |e| SexpParser.call(e, parent: self) }
    end

    def token_tree
      Group.new(
        Token.new("["),
        INDENT,
        SOFTLINE,
        Intersperse.call(super, [Token.new(","), LINE]),
        DEDENT,
        SOFTLINE,
        Token.new("]"),
      )
    end
  end

  class ArgsAddStar < Node
  end

  class BeginNode < Node
    # def parse_elements(elements)
      # fail elements.ai
      # elements.flatten(1).compact.map { |e| SexpParser.call(e, parent: self) }
    # end

    def token_tree
      if elements.flat_map(&:elements).all? { |e| e.is_a? VoidStatement }
        [
          Token.new("begin"),
          HARDLINE,
          Token.new("end"),
        ]
      else
        [
          Token.new("begin"),
          INDENT,
          HARDLINE,
          super,
          DEDENT,
          HARDLINE,
          Token.new("end"),
        ]
      end
    end
  end

  class RescueNode < Node
    def parse_elements(elements)
      if elements.first == :mrhs_new_from_args
        super
      else
        elements.map do |element|
          element && element.map { |e| SexpParser.call(e, parent: self) }
        end
      end
    end

    def token_tree
      [
        DEDENT,
        Token.new("rescue"),
        elements[0] && [Token.new(" "), elements[0].map(&:token_tree)],
        INDENT,
        HARDLINE,
        elements[2].map(&:token_tree),
      ].compact
    end
  end

  class VoidStatement < Node
    def parse_elements(elements)
      []
    end
  end

  class MrhsNewFromArgs < Node
    # def parse_elements(elements)
    #   fail elements.ai
    # end
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
    :@int => IntegerNode,
    :@float => FloatNode,
    array: ArrayNode,
    args_add_star: ArgsAddStar,
    begin: BeginNode,
    rescue: RescueNode,
    void_stmt: VoidStatement,
    :@const => ConstantNode,
    mrhs_new_from_args: MrhsNewFromArgs,
  }

  SexpParser = lambda do |sexp, parent: nil|
    type, *rest = sexp

    begin
      if type == :mrhs_new_from_args
        ap(s: sexp,t: type, rest: rest, parent: parent)
        # fail parent.elements.ai
        TYPE_MAP.fetch(type).new(*rest, parent: parent)
      else
        TYPE_MAP.fetch(type).new(*rest, parent: parent)
      end
    rescue KeyError
      fail "Unknown type: #{type}\n\n#{parent.ai(raw: true)}"
    end
  end
end
