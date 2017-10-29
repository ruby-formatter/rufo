require "spec_helper"

RSpec.describe Rufo::Settings do
  class TestClass
    include Rufo::Settings
  end

  subject { TestClass.new }

  describe 'settings' do
    it 'does not output any warnings for expected settings' do
      expect {
        subject.init_settings(spaces_around_binary: :dynamic)
      }.to output('').to_stderr
    end

    it 'outputs a warning for invalid config value' do
      exp_msg = "Invalid value for spaces_around_binary: :fake. Valid values " \
      "are: :dynamic, :one\n"
      expect {
        subject.init_settings(spaces_around_binary: :fake)
      }.to output(exp_msg).to_stderr
    end

    it 'outputs a warning for invalid config option' do
      exp_msg = "Invalid config option=fake\n"
      expect {
        subject.init_settings(fake: :fake_too)
      }.to output(exp_msg).to_stderr
    end
  end
end
