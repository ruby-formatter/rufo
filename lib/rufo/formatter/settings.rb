class Rufo::Formatter
  OPTIONS = {
    spaces_around_binary: [:dynamic, :one],
    parens_in_def: [:yes, :dynamic],
    double_newline_inside_type: [:dynamic, :no],
    align_case_when: [false, true],
    align_chained_calls: [false, true],
    trailing_commas: [:always, :never],
  }

  attr_accessor *OPTIONS.keys

  def init_settings(options)
    OPTIONS.each do |name, valid_options|
      default = valid_options.first
      value = options.fetch(name, default)
      unless valid_options.include?(value)
        STDERR.puts "invalid value for #{name}: #{value}. Valid values are: " \
                    "#{valid_options.join(', ')}"
        value = default
      end
      self.send("#{name}=", value)
    end
    diff = options.keys - OPTIONS.keys
    diff.each do |key|
      STDERR.puts "invalid config option=#{key}"
    end
  end
end
