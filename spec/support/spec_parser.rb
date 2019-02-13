class SpecParser
  def self.parse(file_path)
    tests = []
    current_test = nil
    File.foreach(file_path).with_index do |line, index|
      case
      when line =~ /^#~# ORIGINAL ?([\w\s]+)$/
        # save old test
        tests.push current_test if current_test

        # start a new test

        name = $~[1].strip
        name = "unnamed test" if name.empty?

        current_test = { name: name, line: index + 1, options: {}, original: "" }
      when line =~ /^#~# EXPECTED$/
        current_test[:expected] = ""
      when line =~ /^#~# PENDING$/
        current_test[:pending] = true
      when line =~ /^#~# (.+)$/
        current_options = current_test[:options] || {}
        current_test[:options] = current_options.merge(eval("{ #{$~[1]} }"))
      when current_test[:expected]
        current_test[:expected] += line
      when current_test[:original]
        current_test[:original] += line
      end
    end
    tests << current_test

    tests
  end
end
