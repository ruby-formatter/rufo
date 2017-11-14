module Rufo::Settings
  OPTIONS = {
    parens_in_def: [:yes, :dynamic],
    align_case_when: [false, true],
    align_chained_calls: [false, true],
    trailing_commas: [true, false],
    print_width: (1..Float::INFINITY)
  }

  DEFAULT_VALUES = {
    print_width: 80
  }

  attr_accessor *OPTIONS.keys

  def init_settings(options)
    OPTIONS.each do |name, valid_options|
      if DEFAULT_VALUES.has_key?(name)
        default = DEFAULT_VALUES[name]
      else
        default = valid_options.first
      end
      value = options.fetch(name, default)
      unless valid_options.include?(value)
        $stderr.puts "Invalid value for #{name}: #{value.inspect}. Valid " \
                      "values are: #{valid_options.map(&:inspect).join(', ')}"
        value = default
      end
      self.public_send("#{name}=", value)
    end
    diff = options.keys - OPTIONS.keys
    diff.each do |key|
      $stderr.puts "Invalid config option=#{key}"
    end
  end
end
