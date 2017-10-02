class Rufo::Formatter
  def init_settings(options)
    indent_size options.fetch(:indent_size, 2)
    spaces_inside_hash_brace options.fetch(:spaces_inside_hash_brace, :dynamic)
    spaces_around_binary options.fetch(:spaces_around_binary, :dynamic)
    parens_in_def options.fetch(:parens_in_def, :dynamic)
    double_newline_inside_type options.fetch(:double_newline_inside_type, :dynamic)
    visibility_indent options.fetch(:visibility_indent, :dynamic)
    align_case_when options.fetch(:align_case_when, false)
    align_chained_calls options.fetch(:align_chained_calls, false)
    trailing_commas options.fetch(:trailing_commas, :dynamic)
  end

  def indent_size(value)
    @indent_size = value
  end

  def spaces_inside_hash_brace(value)
    @spaces_inside_hash_brace = dynamic_always_never_match("spaces_inside_hash_brace", value)
  end

  def spaces_around_binary(value)
    @spaces_around_binary = one_dynamic("spaces_around_binary", value)
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
