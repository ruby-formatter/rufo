# frozen_string_literal: true

module Rufo::Settings
  OPTIONS = {
    parens_in_def: %i[yes dynamic],
    align_case_when: [false, true],
    align_chained_calls: [false, true],
    trailing_commas: [true, false],
    quote_style: %i[double single],
  }.freeze

  attr_accessor(*OPTIONS.keys)

  def init_settings(options)
    OPTIONS.each do |name, valid_options|
      default = valid_options.first
      value = options.fetch(name, default)
      unless valid_options.include?(value)
        warn "Invalid value for #{name}: #{value.inspect}. Valid " \
             "values are: #{valid_options.map(&:inspect).join(", ")}"
        value = default
      end
      public_send("#{name}=", value)
    end
    diff = options.keys - OPTIONS.keys
    diff.each do |key|
      warn "Invalid config option=#{key}"
    end
  end
end
