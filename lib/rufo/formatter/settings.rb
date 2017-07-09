class Rufo::Formatter
  def init_settings(options)
    indent_size                  options.fetch(:indent_size,                  2)
    spaces_inside_hash_brace     options.fetch(:spaces_inside_hash_brace,     :dynamic)
    spaces_inside_array_bracket  options.fetch(:spaces_inside_array_bracket,  :dynamic)
    spaces_around_equal          options.fetch(:spaces_around_equal,          :dynamic)
    spaces_in_ternary            options.fetch(:spaces_in_ternary,            :dynamic)
    spaces_in_suffix             options.fetch(:spaces_in_suffix,             :dynamic)
    spaces_in_commands           options.fetch(:spaces_in_commands,           :dynamic)
    spaces_around_block_brace    options.fetch(:spaces_around_block_brace,    :dynamic)
    spaces_after_comma           options.fetch(:spaces_after_comma,           :dynamic)
    spaces_around_hash_arrow     options.fetch(:spaces_around_hash_arrow,     :dynamic)
    spaces_around_when           options.fetch(:spaces_around_when,           :dynamic)
    spaces_around_dot            options.fetch(:spaces_around_dot,            :dynamic)
    spaces_after_lambda_arrow    options.fetch(:spaces_after_lambda_arrow,    :dynamic)
    spaces_around_unary          options.fetch(:spaces_around_unary,          :dynamic)
    spaces_around_binary         options.fetch(:spaces_around_binary,         :dynamic)
    spaces_after_method_name     options.fetch(:spaces_after_method_name,     :dynamic)
    spaces_in_inline_expressions options.fetch(:spaces_in_inline_expressions, :dynamic)
    parens_in_def                options.fetch(:parens_in_def,                :dynamic)
    double_newline_inside_type   options.fetch(:double_newline_inside_type,   :dynamic)
    visibility_indent            options.fetch(:visibility_indent,            :dynamic)
    align_comments               options.fetch(:align_comments,               false)
    align_assignments            options.fetch(:align_assignments,            false)
    align_hash_keys              options.fetch(:align_hash_keys,              false)
    align_case_when              options.fetch(:align_case_when,              false)
    align_chained_calls          options.fetch(:align_chained_calls,          false)
    trailing_commas              options.fetch(:trailing_commas,              :dynamic)
  end

  def indent_size(value)
    @indent_size = value
  end

  def spaces_inside_hash_brace(value)
    @spaces_inside_hash_brace = dynamic_always_never_match("spaces_inside_hash_brace", value)
  end

  def spaces_inside_array_bracket(value)
    @spaces_inside_array_bracket = dynamic_always_never_match("spaces_inside_array_bracket", value)
  end

  def spaces_around_equal(value)
    @spaces_around_equal = one_dynamic("spaces_around_equal", value)
  end

  def spaces_in_ternary(value)
    @spaces_in_ternary = one_dynamic("spaces_in_ternary", value)
  end

  def spaces_in_suffix(value)
    @spaces_in_suffix = one_dynamic("spaces_in_suffix", value)
  end

  def spaces_in_commands(value)
    @spaces_in_commands = one_dynamic("spaces_in_commands", value)
  end

  def spaces_around_block_brace(value)
    @spaces_around_block_brace = one_dynamic("spaces_around_block_brace", value)
  end

  def spaces_after_comma(value)
    @spaces_after_comma = one_dynamic("spaces_after_comma", value)
  end

  def spaces_around_hash_arrow(value)
    @spaces_around_hash_arrow = one_dynamic("spaces_around_hash_arrow", value)
  end

  def spaces_around_when(value)
    @spaces_around_when = one_dynamic("spaces_around_when", value)
  end

  def spaces_around_dot(value)
    @spaces_around_dot = no_dynamic("spaces_around_dot", value)
  end

  def spaces_after_lambda_arrow(value)
    @spaces_after_lambda_arrow = one_no_dynamic("spaces_after_lambda_arrow", value)
  end

  def spaces_around_unary(value)
    @spaces_around_unary = no_dynamic("spaces_around_unary", value)
  end

  def spaces_around_binary(value)
    @spaces_around_binary = one_dynamic("spaces_around_binary", value)
  end

  def spaces_after_method_name(value)
    @spaces_after_method_name = no_dynamic("spaces_after_method_name", value)
  end

  def spaces_in_inline_expressions(value)
    @spaces_in_inline_expressions = one_dynamic("spaces_in_inline_expressions", value)
  end

  def parens_in_def(value)
    @parens_in_def = yes_dynamic("parens_in_def", value)
  end

  def double_newline_inside_type(value)
    @double_newline_inside_type = no_dynamic("double_newline_inside_type", value)
  end

  def trailing_commas(value)
    case value
    when :dynamic, :always, :never
      @trailing_commas = value
    else
      raise ArgumentError.new("invalid value for trailing_commas: #{value}. Valid values are: :dynamic, :always, :never")
    end
  end

  def visibility_indent(value)
    case value
    when :indent, :align, :dynamic #, :dedent
      @visibility_indent = value
    else
      raise ArgumentError.new("invalid value for visibility_indent: #{value}. Valid values are: :indent, :align, :dynamic")
    end
  end

  def align_comments(value)
    @align_comments = value
  end

  def align_assignments(value)
    @align_assignments = value
  end

  def align_hash_keys(value)
    @align_hash_keys = value
  end

  def align_case_when(value)
    @align_case_when = value
  end

  def align_chained_calls(value)
    @align_chained_calls = value
  end

  def dynamic_always_never(name, value)
    case value
    when :dynamic, :always, :never
      value
    else
      raise ArgumentError.new("invalid value for #{name}: #{value}. Valid values are: :dynamic, :always, :never")
    end
  end

  def dynamic_always_never_match(name, value)
    case value
    when :dynamic, :always, :never, :match
      value
    else
      raise ArgumentError.new("invalid value for #{name}: #{value}. Valid values are: :dynamic, :always, :never, :match")
    end
  end

  def one_dynamic(name, value)
    case value
    when :one, :dynamic
      value
    else
      raise ArgumentError.new("invalid value for #{name}: #{value}. Valid values are: :one, :dynamic")
    end
  end

  def no_dynamic(name, value)
    case value
    when :no, :dynamic
      value
    else
      raise ArgumentError.new("invalid value for #{name}: #{value}. Valid values are: :no, :dynamic")
    end
  end

  def one_no_dynamic(name, value)
    case value
    when :no, :one, :dynamic
      value
    else
      raise ArgumentError.new("invalid value for #{name}: #{value}. Valid values are: :no, :one, :dynamic")
    end
  end

  def yes_dynamic(name, value)
    case value
    when :yes, :dynamic
      value
    else
      raise ArgumentError.new("invalid value for #{name}: #{value}. Valid values are: :yes, :dynamic")
    end
  end
end
