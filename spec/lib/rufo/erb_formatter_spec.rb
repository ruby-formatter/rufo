require "spec_helper"

RSpec.describe Rufo::ErbFormatter do
  subject { described_class }

  describe ".format" do
    it "removes unnecessary spaces from code sections" do
      result = subject.format("Example <%=  a + 5%>")
      expect(result).to eql("Example <%= a + 5 %>")
    end

    it "handles do end blocks" do
      result = subject.format("<% a do |b| %>\nabc\n<% end %>")
      expect(result).to eql("<% a do |b| %>\nabc\n<% end %>")
    end

    it "handles {} blocks" do
      result = subject.format("<% a { |b| %>\nabc\n<% } %>")
      expect(result).to eql("<% a { |b| %>\nabc\n<% } %>")
    end

    it "handles rescue statements" do
      result = subject.format("<% begin %>\na\n<% rescue %>\n<% end %>")
      expect(result).to eql("<% begin %>\na\n<% rescue %>\n<% end %>")
    end

    it "handles multiline statements" do
      result = subject.format("<% link_to :a,\n:b %>")
      expect(result).to eql("<% link_to :a,\n        :b %>")
    end

    it "handles invalid code" do
      expect { subject.format("\n\n<% a+ %>") }.to raise_error { |error|
        expect(error).to be_a(Rufo::SyntaxError)
        expect(error.lineno).to eql(3)
      }
    end
  end
end
