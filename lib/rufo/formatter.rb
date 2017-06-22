require "ripper"

class Rufo::Formatter
  def self.format(code)
    formatter = new(code)
    formatter.format
    formatter.result
  end

  def initialize(code)
    @code = code
    @tokens = Ripper.lex(code).reverse!
    @sexp = Ripper.sexp(code)
    @indent = 0
    @line = 0
    @column = 0
    @last_was_newline = false
    @output = ""
    @indent_size = 2

    # The column of a `obj.method` call, so we can align
    # calls to that dot
    @dot_column = nil
  end

  def format
    visit @sexp
    write_line unless @last_was_newline
  end

  def visit(node)
    case node.first
    when :program
      # Topmost node
      #
      # [:program, exps]
      visit_exps node[1]
    when :void_stmt
      # Empty statement
      #
      # [:void_stmt]
      skip_space_or_newline
    when :@int
      # Number literal
      #
      # [:@int, "123", [1, 0]]
      consume_token :on_int
    when :string_literal
      visit_string_literal node
    when :@tstring_content
      # [:@tstring_content, "hello ", [1, 1]]
      consume_token :on_tstring_content
    when :string_embexpr
      # String interpolation piece ( #{exp} )
      visit_string_interpolation node
    when :symbol_literal
      visit_symbol_literal(node)
    when :dyna_symbol
      visit_quoted_symbol_literal(node)
    when :@ident
      consume_token :on_ident
    when :var_ref
      # [:var_ref, exp]
      visit node[1]
    when :var_field
      # [:var_field, exp]
      visit node[1]
    when :@kw
      # [:@kw, "nil", [1, 0]]
      consume_token :on_kw
    when :@ivar
      # [:@ivar, "@foo", [1, 0]]
      consume_token :on_ivar
    when :@const
      # [:@const, "FOO", [1, 0]]
      consume_token :on_const
    when :const_ref
      # [:const_ref, [:@const, "Foo", [1, 8]]]
      visit node[1]
    when :const_path_ref
      visit_path(node)
    when :assign
      visit_assign(node)
    when :ifop
      visit_ternary_if(node)
    when :if_mod
      visit_suffix(node, "if")
    when :unless_mod
      visit_suffix(node, "unless")
    when :rescue_mod
      visit_suffix(node, "rescue")
    when :while_mod
      visit_suffix(node, "while")
    when :vcall
      # [:vcall, exp]
      visit node[1]
    when :fcall
      # [:fcall, [:@ident, "foo", [1, 0]]]
      visit node[1]
    when :command
      visit_command(node)
    when :args_add_block
      visit_call_args(node)
    when :args_add_star
      visit_args_add_star(node)
    when :bare_assoc_hash
      # **x, **y, ...
      # 
      # [:bare_assoc_hash, exps]
      visit_comma_separated_list node[1]
    when :method_add_arg
      visit_call_without_receiver(node)
    when :method_add_block
      visit_call_with_block(node)
    when :call
      visit_call_with_receiver(node)
    when :brace_block
      visit_brace_block(node)
    when :do_block
      visit_do_block(node)
    when :block_var
      visit_block_arguments(node)
    when :begin
      visit_begin(node)
    when :bodystmt
      visit_bodystmt(node)
    when :if
      visit_if(node)
    when :unless
      visit_unless(node)
    when :while
      visit_while(node)
    when :case
      visit_case(node)
    when :when
      visit_when(node)
    when :unary
      visit_unary(node)
    when :binary
      visit_binary(node)
    when :class
      visit_class(node)
    when :module
      visit_module(node)
    when :mrhs_new_from_args
      visit_mrhs_new_from_args(node)
    when :mlhs_paren
      visit_mlhs_paren(node)
    when :def
      visit_def(node)
    when :defs
      visit_def_with_receiver(node)
    when :paren
      visit_paren(node)
    when :params
      visit_params(node)
    when :array
      visit_array(node)
    when :hash
      visit_hash(node)
    when :assoc_new
      visit_hash_key_value(node)
    when :assoc_splat
      visit_splat_inside_hash(node)
    when :@label
      # [:@label, "foo:", [1, 3]]
      write node[1]
      next_token
    when :dot2
      visit_range(node, true)
    when :dot3
      visit_range(node, false)
    when :regexp_literal
      visit_regexp_literal(node)
    else
      raise "Unhandled node: #{node.first}"
    end
  end

  def visit_exps(exps, with_indent = false, with_lines = true)
    consume_end_of_line(true)

    line_before_endline = nil

    exps.each_with_index do |exp, i|
      exp_kind = exp[0]

      # Skip voids to avoid extra indentation
      if exp_kind == :void_stmt
        next
      end

      if with_indent
        # Don't indent if this exp is in the same line as the previous
        # one (this happens when there's a semicolon between the exps)
        unless line_before_endline && line_before_endline == @line
          write_indent 
        end
      end

      visit exp

      line_before_endline = @line

      is_last = last?(i, exps)
      if with_lines
        consume_end_of_line(false, !is_last, !is_last)

        # Make sure to put two lines before defs
        if !is_last && needs_two_lines?(exp_kind) && @line <= line_before_endline + 1
          write_line
        end
      else
        skip_space_or_newline(!is_last)
      end
    end
  end

  def needs_two_lines?(exp_kind)
    case exp_kind
    when :def, :class, :module
      true
    else
      false
    end
  end

  def visit_string_literal(node)
    # [:string_literal, [:string_content, exps]]
    consume_token :on_tstring_beg
    visit_exps(node[1][1..-1], false, false)
    consume_token :on_tstring_end
  end

  def visit_string_interpolation(node)
    # [:string_embexpr, exps]
    consume_token :on_embexpr_beg
    skip_space_or_newline
    visit_exps node[1], false, false
    consume_token :on_embexpr_end
  end

  def visit_symbol_literal(node)
    # :foo
    #
    # [:symbol_literal, [:symbol, [:@ident, "foo", [1, 1]]]]
    consume_token :on_symbeg
    visit_exps node[1][1..-1], false, false
  end

  def visit_quoted_symbol_literal(node)
    # :"foo"
    #
    # [:dyna_symbol, exps]
    consume_token :on_symbeg
    visit_exps node[1], false, false
    consume_token :on_tstring_end
  end

  def visit_path(node)
    # Foo::Bar
    #
    # [:const_path_ref,
    #   [:var_ref, [:@const, "Foo", [1, 0]]],
    #   [:@const, "Bar", [1, 5]]]
    pieces = node[1..-1]
    pieces.each_with_index do |piece, i|
      visit piece
      unless last?(i, pieces)
        consume_op "::" 
        skip_space_or_newline
      end
    end
  end

  def visit_assign(node)
    # target = value
    #
    # [:assign, target, value]
    _, target, value = node

    visit target
    consume_space
    consume_op "="
    skip_space
    if current_token_kind == :on_kw && (current_token_value == "if" || current_token_value == "unless" || current_token_value == "begin")
      indent_after_space value, true
    else
      indent_after_space value
    end
  end

  def visit_ternary_if(node)
    # cond ? then : else
    #
    # [:ifop, cond, then_body, else_body]
    _, cond, then_body, else_body = node

    visit cond
    consume_space
    consume_op "?"
    consume_space
    visit then_body
    consume_space
    consume_op ":"
    consume_space
    visit else_body
  end

  def visit_suffix(node, suffix)
    # then if cond
    # then unless cond
    # exp rescue handler
    #
    # [:if_mod, cond, body]
    _, cond, body = node

    visit body
    consume_space
    consume_keyword(suffix)
    consume_space
    visit cond
  end

  def visit_call_with_receiver(node)
    # [:call, obj, :".", call]
    _, obj, text, call = node

    @dot_column = nil
    visit obj

    skip_space

    if newline? || comment?
      consume_end_of_line

      write_indent(@dot_column || next_indent)
    end

    # Remember dot column
    dot_column = @column
    consume_call_dot

    skip_space

    if newline? || comment?
      consume_end_of_line
      write_indent(next_indent)
    else
      skip_space_or_newline
    end

    visit call

    # Only set it after we visit the call after the dot,
    # so we remember the outmost dot position
    @dot_column = dot_column
  end

  def consume_call_dot
    if current_token_kind == :on_op
      consume_op "::"
    else
      check :on_period
      next_token
      write "."
    end
  end

  def visit_call_without_receiver(node)
    # foo(arg1, ..., argN)
    #
    # [:method_add_arg, 
    #   [:fcall, [:@ident, "foo", [1, 0]]], 
    #   [:arg_paren, [:args_add_block, [[:@int, "1", [1, 6]]], false]]]
    _, name, args = node

    visit name

    # Some times a call comes without parens (should probably come as command, but well...)
    return if args.empty?

    # Remember dot column so it's not affected by args
    dot_column = @dot_column

    consume_token :on_lparen

    # If there's a trailing comma then comes [:arg_paren, args],
    # which is a bit unexpected, so we fix it
    if args[1].is_a?(Array) && args[1][0].is_a?(Array)
      args_node = [:args_add_block, args[1], false]
    else
      args_node = args[1]
    end

    if args_node
      skip_space

      needs_trailing_newline = newline? || comment?

      if newline? || comment?
        indent_size = next_indent
        indent(indent_size) do
          consume_end_of_line
          write_indent
          visit args_node
        end
      else
        indent_size = @column
        indent(indent_size) do
          visit args_node
        end
      end

      found_comma = comma?

      if found_comma
        if needs_trailing_newline
          write ","
          next_token
          indent(indent_size) do
            consume_end_of_line
          end
          write_indent
        else
          next_token
          skip_space
        end
      end

      if newline? || comment?
        if needs_trailing_newline
          indent(indent_size) do
            consume_end_of_line
          end
          write_indent
        else
          skip_space_or_newline
        end
      else
        if needs_trailing_newline && !found_comma
          consume_end_of_line
          write_indent
        end
      end
    else
      skip_space_or_newline
    end
    consume_token :on_rparen

    # Restore dot column so it's not affected by args
    @dot_column = dot_column
  end

  def visit_command(node)
    # foo arg1, ..., argN
    #
    # [:command, name, args]
    _, name, args = node

    visit name
    consume_space

    indent(@column) do
      visit args
    end
  end

  def visit_call_with_block(node)
    # [:method_add_block, call, block]
    _, call, block = node

    visit call

    consume_space
    visit block
  end

  def visit_brace_block(node)
    # [:brace_block, args, body]
    _, args, body = node

    # This is for the empty `{ }` block
    if void_exps?(body)
      check :on_lbrace
      write "{"
      next_token

      consume_block_args args
      consume_space

      check :on_rbrace
      write "}"
      next_token
      return
    end

    closing_brace_token = find_closing_brace_token

    # If the whole block fits into a single line, use braces
    if current_token[0][0] == closing_brace_token[0][0]
      check :on_lbrace
      write "{"
      next_token

      consume_block_args args

      consume_space
      visit_exps body, false, false
      consume_space

      check :on_rbrace
      write "}"
      next_token
      return
    end

    # Otherwise, use `do`
    check :on_lbrace
    write "do"
    next_token

    consume_block_args args

    indent_body body

    write_indent

    check :on_rbrace
    next_token
    write "end"
  end

  def visit_do_block(node)
    # [:brace_block, args, body]
    _, args, body = node

    consume_keyword "do"

    consume_block_args args

    indent_body body

    write_indent
    consume_keyword "end"
  end

  def consume_block_args(args)
    if args
      consume_space
      # + 1 because of |...|
      #                ^
      indent(@column + 1) do
        visit args
      end
    end
  end

  def visit_block_arguments(node)
    # [:block_var, params, ??]
    _, params = node

    consume_op "|"
    skip_space_or_newline

    visit params

    skip_space_or_newline
    consume_op "|"
  end

  def visit_call_args(node)
    # [:args_add_block, args, block]
    _, args, block = node

    if !args.empty? && args[0] == :args_add_star
      # arg1, ..., *star
      visit args
    else
      visit_comma_separated_list args
    end
  end

  def visit_args_add_star(node)
    # [:args_add_star, args, star]
    _, args, star = node

    if !args.empty? && args[0] == :args_add_star
      # arg1, ..., *star
      visit args
    else
      visit_comma_separated_list args
    end

    skip_space
    check :on_comma
    write ", "
    next_token
    skip_space_or_newline
    consume_op "*"
    skip_space_or_newline
    visit star
  end

  def visit_begin(node)
    # begin
    #   body
    # end
    #
    # [:begin, [:bodystmt, body, rescue_body, else_body, ensure_body]]
    consume_keyword "begin"
    visit node[1]
  end

  def visit_bodystmt(node)
    # [:bodystmt, body, rescue_body, else_body, ensure_body]
    _, body, rescue_body, else_body, ensure_body = node
    indent_body body

    if rescue_body
      # [:rescue, type, name, body, nil]
      _, type, name, body = rescue_body
      write_indent
      consume_keyword "rescue"
      if type
        skip_space
        write " "
        indent(@column) do
          visit_rescue_types(type)
        end
      end

      if name
        skip_space
        write " "
        consume_op "=>"
        skip_space
        write " "
        visit name
      end

      indent_body body
    end

    if else_body
      # [:else, body]
      write_indent
      consume_keyword "else"
      indent_body else_body[1]
    end

    if ensure_body
      # [:ensure, body]
      write_indent
      consume_keyword "ensure"
      indent_body ensure_body[1]
    end

    write_indent
    consume_keyword "end"
  end

  def visit_rescue_types(node)
    if node[0] == :mrhs_new_from_args
      visit node
    else
      visit_exps node, false, false
    end
  end

  def visit_mrhs_new_from_args(node)
    # Multiple exception types
    # [:mrhs_new_from_args, exps, final_exp]
    nodes = [*node[1], node[2]]
    visit_comma_separated_list(nodes)
  end

  def visit_mlhs_paren(node)
    # [:mlhs_paren, 
    #   [[:mlhs_paren, [:@ident, "x", [1, 12]]]]
    # ]
    _, args = node

    # For some reason there's nested :mlhs_paren for
    # a single parentheses. It seems when there's
    # a nested array we need parens, otherwise we
    # just output whatever's inside `args`.
    if args.is_a?(Array) && args[0].is_a?(Array)
      check :on_lparen
      write "("
      next_token
      skip_space_or_newline

      indent(@column) do
        visit_comma_separated_list args
      end

      check :on_rparen
      write ")"
      next_token
    else
      visit args
    end
  end

  def visit_comma_separated_list(nodes)
    nodes.each_with_index do |exp, i|
      if block_given?
        yield exp
      else
        visit exp
      end
      skip_space
      unless last?(i, nodes)
        check :on_comma
        write ","
        next_token
        skip_space

        if newline? || comment?
          consume_end_of_line(false, false, false)
          write_indent
        else
          write " "
          skip_space_or_newline
        end
      end
    end
  end

  def visit_unary(node)
    # [:unary, :-@, [:vcall, [:@ident, "x", [1, 2]]]]
    check :on_op
    write current_token_value
    next_token
    skip_space_or_newline
    visit node[2]
  end

  def visit_binary(node)
    # [:binary, left, op, right]
    _, left, op, right = node

    visit left
    if current_token_kind == :on_sp
      needs_space = true
    else
      needs_space = op != :* && op != :/ && op != :**
    end
    skip_space
    write " " if needs_space
    check :on_op
    write current_token_value
    next_token
    indent_after_space right, false, needs_space
  end

  def visit_class(node)
    # [:class,
    #   name
    #   superclass
    #   [:bodystmt, body, nil, nil, nil]]
    _, name, superclass, body = node

    consume_keyword "class"
    skip_space_or_newline
    write " "
    visit name

    if superclass
      skip_space_or_newline
      write " "
      consume_op "<"
      skip_space_or_newline
      write " "
      visit superclass
    end

    maybe_inline_body body
  end

  def visit_module(node)
    # [:module,
    #   name
    #   [:bodystmt, body, nil, nil, nil]]
    _, name, body = node

    consume_keyword "module"
    skip_space_or_newline
    write " "
    visit name
    maybe_inline_body body
  end

  def maybe_inline_body(body)
    skip_space
    if semicolon? && empty_body?(body)
      next_token
      skip_space
      if newline?
        skip_space_or_newline
        visit body
      else
        write "; "
        skip_space_or_newline
        consume_keyword "end"
      end
    else
      visit body
    end
  end

  def visit_def(node)
    # [:def,
    #   [:@ident, "foo", [1, 6]],
    #   [:params, nil, nil, nil, nil, nil, nil, nil],
    #   [:bodystmt, [[:void_stmt]], nil, nil, nil]]
    _, name, params, body = node

    consume_keyword "def"
    consume_space
    visit_def_from_name name, params, body
  end

  def visit_def_with_receiver(node)
    # [:defs,
    # [:vcall, [:@ident, "foo", [1, 5]]],
    # [:@period, ".", [1, 8]],
    # [:@ident, "bar", [1, 9]],
    # [:params, nil, nil, nil, nil, nil, nil, nil],
    # [:bodystmt, [[:void_stmt]], nil, nil, nil]]
    _, receiver, period, name, params, body = node

    consume_keyword "def"
    consume_space
    visit name
    skip_space_or_newline

    check :on_period
    write "."
    next_token
    skip_space_or_newline
    visit_def_from_name name, params, body
  end

  def visit_def_from_name(name, params, body)
    visit name

    if params[0] == :paren
      params = params[1]
    end

    skip_space
    if current_token_kind == :on_lparen
      next_token
      skip_space
      skip_semicolons

      if empty_params?(params)
        skip_space_or_newline
        check :on_rparen
        next_token
        skip_space_or_newline
      else
        write "("

        if newline? || comment?
          column = @column
          indent(column) do
            consume_end_of_line
            write_indent
            visit params
          end
        else
          indent(@column) do
            visit params
          end
        end

        skip_space_or_newline
        check :on_rparen
        write ")"
        next_token
      end
    elsif !empty_params?(params)
      write "("
      visit params
      write ")"
      skip_space_or_newline
    end

    visit body
  end

  def empty_params?(node)
    _, a, b, c, d, e, f, g = node
    !a && !b && !c && !d && !e && !f && !g
  end

  def visit_paren(node)
    # ( exps )
    #
    # [:paren, exps]
    check :on_lparen
    write "("
    next_token
    skip_space_or_newline
    visit_exps node[1], false, false
    check :on_rparen
    write ")"
    next_token
  end

  def visit_params(node)
    # (def params)
    #
    # [:params, pre_rest_params, args_with_default, rest_param, post_rest_params, label_params, double_star_param, blockarg]
    _, pre_rest_params, args_with_default, rest_param, post_rest_params, label_params, double_star_param, blockarg = node

    needs_comma = false

    if pre_rest_params
      visit_comma_separated_list pre_rest_params
      needs_comma = true
    end

    if args_with_default
      write_params_comma if needs_comma
      visit_comma_separated_list(args_with_default) do |arg, default|
        visit arg
        skip_space
        write " "
        consume_op "="
        skip_space_or_newline
        write " "
        visit default
      end
      needs_comma = true
    end

    if rest_param
      # [:rest_param, [:@ident, "x", [1, 15]]]
      write_params_comma if needs_comma
      consume_op "*"
      skip_space_or_newline
      visit rest_param[1]
      needs_comma = true
    end

    if post_rest_params
      write_params_comma if needs_comma
      visit_comma_separated_list post_rest_params
      needs_comma = true
    end

    if label_params
      # [[label, value], ...]
      write_params_comma if needs_comma
      visit_comma_separated_list(label_params) do |label, value|
        # [:@label, "b:", [1, 20]]
        write label[1]
        next_token
        skip_space_or_newline
        if value
          write " "
          visit value
        end
      end
      needs_comma = true
    end

    if double_star_param
      write_params_comma if needs_comma
      consume_op "**"
      skip_space_or_newline
      visit double_star_param
      skip_space_or_newline
      needs_comma = true
    end

    if blockarg
      # [:blockarg, [:@ident, "block", [1, 16]]]
      write_params_comma if needs_comma
      skip_space_or_newline
      consume_op "&"
      skip_space_or_newline
      visit blockarg[1]
    end
  end

  def write_params_comma
    skip_space
    check :on_comma
    write ","
    next_token
    skip_space

    if newline? || comment?
      consume_end_of_line
      write_indent
    else
      write " "
      skip_space_or_newline
    end
  end

  def visit_array(node)
    # [:array, elements]

    # Check if it's `%w(...)` or `%i(...)`
    if current_token_kind == :on_qwords_beg  || current_token_kind == :on_qsymbols_beg
      visit_q_or_i_array(node)
      return
    end

    _, elements = node

    check :on_lbracket
    write "["
    next_token

    if elements
      visit_literal_elements elements
    else
      skip_space_or_newline
    end

    check :on_rbracket
    write "]"
    next_token
  end

  def visit_q_or_i_array(node)
    _, elements = node

    write current_token_value.strip

    # If there's a newline after `%w(`, write line and indent
    if current_token_value.include?("\n") && elements
      write_line
      write_indent(next_indent)
    end

    next_token

    if elements
      elements.each_with_index do |elem, i|
        # elem is [:@tstring_content, string, [1, 5]
        write elem[1].strip
        next_token
        unless last?(i, elements)
          check :on_words_sep

          # On a newline, write line and indent
          if current_token_value.include?("\n")
            next_token
            write_line
            write_indent(next_indent)
          else
            next_token
            write " " 
          end
        end
      end
    end

    has_newline = false

    while current_token_kind == :on_words_sep
      has_newline ||= current_token_value.include?("\n")
      next_token
    end

    if has_newline
      write_line
      write_indent(next_indent)
    end

    write ")"
    return
  end

  def visit_hash(node)
    # [:hash, elements]
    _, elements = node

    check :on_lbrace
    write "{"
    next_token

    if elements
      # [:assoclist_from_args, elements]
      visit_literal_elements(elements[1])
    else
      skip_space_or_newline
    end

    check :on_rbrace
    write "}"
    next_token
  end

  def visit_hash_key_value(node)
    # key => value
    #
    # [:assoc_new, key, value]
    _, key, value = node

    visit key
    
    skip_space_or_newline
    write " "

    # Don't output `=>` for keys that are `label: value`
    unless key[0] == :@label
      consume_op "=>"
      skip_space_or_newline
      write " "
    end

    visit value
  end

  def visit_splat_inside_hash(node)
    # **exp
    #
    # [:assoc_splat, exp]
    consume_op "**"
    skip_space_or_newline
    visit node[1]
  end

  def visit_range(node, inclusive)
    # [:dot2, left, right]
    _, left, right = node

    visit left
    skip_space_or_newline
    consume_op(inclusive ? ".." : "...")
    skip_space_or_newline
    visit right
  end

  def visit_regexp_literal(node)
    # [:regexp_literal, pieces, [:@regexp_end, "/", [1, 1]]]
    _, pieces = node

    check :on_regexp_beg
    write current_token_value
    next_token

    visit_exps pieces, false, false

    check :on_regexp_end
    write current_token_value
    next_token
  end

  def visit_literal_elements(elements)
    base_column = @column

    skip_space

    # If there's a newline right at the beginning,
    # write it, and we'll indent element and always
    # add a trailing comma to the last element
    needs_trailing_comma = newline? || comment?
    if needs_trailing_comma
      needed_indent = next_indent
      indent { consume_end_of_line }
      write_indent(needed_indent)
    else
      needed_indent = base_column
    end

    elements.each_with_index do |elem, i|
      indent(needed_indent) { visit elem }
      skip_space

      if comma?
        is_last = last?(i, elements)

        write "," unless is_last
        next_token
        skip_space

        if newline? || comment?
          if is_last
            # Nothing
          else
            consume_end_of_line
            write_indent(needed_indent)
          end
        else
          write " " unless is_last
        end
      end
    end

    if needs_trailing_comma
      write ","
      consume_end_of_line
      write_indent
    elsif comment?
      consume_end_of_line
    else
      skip_space_or_newline
    end
  end

  def visit_if(node)
    visit_if_or_unless node, "if"
  end

  def visit_unless(node)
    visit_if_or_unless node, "unless"
  end

  def visit_if_or_unless(node, keyword)
    # if cond
    #   then_body
    # else
    #   else_body
    # end
    #
    # [:if, cond, then, else]
    consume_keyword(keyword)
    consume_space
    visit node[1]
    skip_space

    # Remove "then"
    if keyword?("then")
      next_token
      skip_space
    end

    indent_body node[2]
    if else_body = node[3]
      # [:else, else_contents]
      write_indent
      consume_keyword "else"
      indent_body else_body[1]
    end
    write_indent
    consume_keyword "end"
  end

  def visit_while(node)
    # [:while, cond, body]
    _, cond, body = node

    consume_keyword "while"
    consume_space

    visit cond

    skip_space

    # Keep `while cond; end` as is
    if semicolon? && void_exps?(body)
      next_token
      skip_space

      if keyword?("end")
        write "; end"
        next_token
        return
      end
    end

    indent_body body

    write_indent
    consume_keyword "end"
  end

  def visit_case(node)
    # [:case, cond, case_when]
    _, cond, case_when = node

    consume_keyword "case"

    if cond
      consume_space
      visit cond
    end

    consume_end_of_line

    write_indent
    visit case_when

    write_indent
    consume_keyword "end"
  end

  def visit_when(node)
    # [:when, conds, body, next_exp]
    _, conds, body, next_exp = node

    consume_keyword "when"
    consume_space

    indent(@column) do
      visit_comma_separated_list conds
    end

    then_keyword = keyword?("then")
    inline = then_keyword || semicolon?
    if then_keyword
      next_token
      skip_space
      skip_semicolons

      if newline? || comment?
        inline = false
      else
        write " then "
      end
    elsif semicolon?
      skip_semicolons

      if newline? || comment?
        inline = false
      else
        write "; "
      end
    end

    if inline
      indent do
        visit_exps body
      end
    else
      indent_body body
    end

    if next_exp
      write_indent

      if next_exp[0] == :else
        # [:else, body]
        consume_keyword "else"
        skip_space

        if newline? || semicolon? || comment?
          indent_body next_exp[1]
        else
          write " "
          visit_exps next_exp[1]
        end
      else
        visit next_exp
      end
    end
  end

  def consume_space
    skip_space_or_newline
    write " "
  end

  def skip_space
    while current_token_kind == :on_sp
      next_token
    end
  end

  def skip_space_or_newline(want_semicolon = false)
    found_newline = false
    found_comment = false
    last = nil

    while true
      case current_token_kind
      when :on_sp
        next_token
      when :on_nl, :on_ignored_nl
        next_token
        last = :newline
        found_newline = true
      when :on_semicolon
        if !found_newline && !found_comment
          write "; "
        end
        next_token
        last = :semicolon
      when :on_comment
        write_line if last == :newline

        write_indent if found_comment
        if current_token_value.end_with?("\n")
          write current_token_value.rstrip
          write_line
        else
          write current_token_value
        end
        next_token
        found_comment = true
        last = :comment
      else
        break
      end
    end
  end

  def skip_semicolons
    while current_token_kind == :on_semicolon || current_token_kind == :on_sp
      next_token
    end
  end

  def empty_body?(body)
    body[0] == :bodystmt &&
      body[1].size == 1 &&
      body[1][0][0] == :void_stmt
  end

  def consume_token(kind)
    check kind
    write current_token_value
    next_token
  end

  def consume_keyword(value)
    check :on_kw
    if current_token_value != value
      raise "Expected keyword #{value}, not #{current_token_value}"
    end
    write value
    next_token
  end

  def consume_op(value)
    check :on_op
    if current_token_value != value
      raise "Expected op #{value}, not #{current_token_value}"
    end
    write value
    next_token
  end

  # Consume and print an end of line, handling semicolons and comments
  # 
  # - at_prefix: are we at a point before an expression? (if so, we don't need a space before the first comment)
  # - want_semicolon: do we want do print a semicolon to separate expressions?
  # - want_multiline: do we want multiple lines to appear, or at most one?
  def consume_end_of_line(at_prefix = false, want_semicolon = false, want_multiline = true)
    found_newline = false             # Did we find any newline during this method?
    last = nil                        # Last token kind found
    multilple_lines = false           # Did we pass through more than one newline?
    last_comment_has_newline = false  # Does the last comment has a newline?

    while true
      case current_token_kind
      when :on_sp
        # Ignore spaces
        next_token
      when :on_nl, :on_ignored_nl
        if last == :newline
          # If we pass through consecutive newlines, don't print them
          # yet, but remember this fact
          multilple_lines = true unless last_comment_has_newline
        else
          # If we just printed a comment that had a newline,
          # we must print two newlines because we remove newlines from comments (rstrip call)
          if last == :comment && last_comment_has_newline
            write_line
            multilple_lines = true
          else
            write_line
            multilple_lines = false
          end
        end
        found_newline = true
        next_token
        last = :newline
      when :on_semicolon
        next_token
        # If we want to print semicolons and we didn't find a newline yet,
        # print it, but only if it's not followed by a newline
        if !found_newline && want_semicolon && last != :semicolon
          skip_space
          case current_token_kind
          when :on_ignored_nl, :on_eof
          else
            write "; "
            last = :semicolon
          end
        end
        multilple_lines = false
      when :on_comment
        if last == :comment
          # Since we remove newlines from comments, we must add the last
          # one if it was a comment
          write_line
          write_indent
        else
          if found_newline
            # Write line or second line if needed
            write_line if last != :newline || multilple_lines
            write_indent
          else
            # If we didn't find any newline yet, this is the first comment,
            # so append a space if needed (for example after an expression)
            write " " unless at_prefix
          end
        end
        last_comment_has_newline = current_token_value.end_with?("\n")
        write current_token_value.rstrip
        next_token
        last = :comment
        multilple_lines = false
      else
        break
      end
    end

    # Output a newline if we didn't do so yet:
    # either we didn't find a newline and we are at the end of a line (and we didn't just pass a semicolon),
    # or the last thing was a comment (from which we removed the newline)
    # or we just passed multiple lines (but printed only one)
    if (!found_newline && !at_prefix && !(want_semicolon && last == :semicolon)) || 
       last == :comment || 
       (multilple_lines && want_multiline)
      write_line 
    end
  end

  def indent(value = nil)
    if value
      old_indent = @indent
      @indent = value
      yield
      @indent = old_indent
    else
      @indent += @indent_size
      yield
      @indent -= @indent_size
    end
  end

  def indent_body(exps)
    indent do
      consume_end_of_line(false, false, false)
    end

    # If the body is [[:void_stmt]] it's an empty body
    # so there's nothing to write
    if exps.size == 1 && exps[0][0] == :void_stmt
      skip_space_or_newline
    else
      indent do
        visit_exps exps, true
      end
      write_line unless @last_was_newline
    end
  end

  def write(value)
    @output << value
    @last_was_newline = false
    @column += value.size
  end

  def write_line
    @output << "\n"
    @last_was_newline = true
    @column = 0
    @line += 1
  end

  def write_indent(indent = @indent)
    indent.times do
      @output << " "
    end
    @column += indent
    @last_was_newline = false
  end

  def indent_after_space(node, sticky = false, want_space = true)
    skip_space
    case current_token_kind
    when :on_ignored_nl, :on_comment
      indent do
        consume_end_of_line
        write_indent
        visit node
      end
    else
      write " " if want_space
      if sticky
        indent(@column) do
          visit node
        end
      else
        visit node
      end
    end
  end

  def next_indent
    @indent + @indent_size
  end

  def check(kind)
    if current_token_kind != kind
      raise "Expected token #{kind}, not #{current_token_kind}"
    end
  end

  # [[1, 0], :on_int, "1"]
  def current_token
    @tokens.last
  end

  def current_token_kind
    tok = current_token
    tok ? tok[1] : :on_eof
  end

  def current_token_value
    tok = current_token
    tok ? tok[2] : ""
  end

  def keyword?(kw)
    current_token_kind == :on_kw && current_token_value == kw
  end

  def newline?
    current_token_kind == :on_nl || current_token_kind == :on_ignored_nl
  end

  def comment?
    current_token_kind == :on_comment
  end

  def semicolon?
    current_token_kind == :on_semicolon
  end

  def comma?
    current_token_kind == :on_comma
  end

  def void_exps?(node)
    node.size == 1 && node[0].size == 1 && node[0][0] == :void_stmt
  end

  def find_closing_brace_token
    count = 0
    @tokens.reverse_each do |token|
      (line, column), kind = token
      case kind
      when :on_lbrace
        count += 1
      when :on_rbrace
        count -= 1
        return token if count == 0
      end
    end
  end

  def next_token
    @tokens.pop
  end

  def last?(i, array)
    i == array.size - 1
  end

  def result
    @output
  end
end