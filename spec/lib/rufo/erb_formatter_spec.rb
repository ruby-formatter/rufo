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

    it "handles if statements" do
      result = subject.format("<% if a %>\na\n<% elsif b %>\n<% end %>")
      expect(result).to eql("<% if a %>\na\n<% elsif b %>\n<% end %>")
    end

    it "handles case statements" do
      result = subject.format("<% case a when a %>\na\n<% when b %>\n<% end %>")
      expect(result).to eql("<% case a\n  when a %>\na\n<% when b %>\n<% end %>")
    end

    it "handles multiline statements" do
      result = subject.format("<% link_to :a,\n:b %>")
      expect(result).to eql("<% link_to :a,\n          :b %>")
    end

    it "handles indented multiline statements" do
      result = subject.format("  <% link_to :a,\n:b %>")
      expect(result).to eql("  <% link_to :a,\n            :b %>")
    end

    it "handles trim mode templates" do
      result = subject.format("<% link_to :a -%>")
      expect(result).to eql("<% link_to :a -%>")
    end

    it "handles rails raw mode templates" do
      result = subject.format("<%== link_to :a %>")
      expect(result).to eql("<%== link_to :a %>")
    end

    it "handles escaped erb templates" do
      result = subject.format("<%%= puts :foo %>")
      expect(result).to eql("<%%= puts :foo %>")
    end

    it "handles escaped rails raw mode erb templates" do
      result = subject.format("<%%== puts :foo %>")
      expect(result).to eql("<%%== puts :foo %>")
    end

    it "handles invalid code" do
      expect { subject.format("\n\n<% a+ %>") }.to raise_error { |error|
        expect(error).to be_a(Rufo::SyntaxError)
        expect(error.lineno).to eql(3)
      }
    end

    it "formats with options" do
      result = subject.format(%(<%= "hello" + ', world' %>), quote_style: :single)
      expect(result).to eql("<%= 'hello' + ', world' %>")
    end

    it "handles literal keywords with code block" do
      result = subject.format("<% if true %>\nabc\n<% end %>")
      expect(result).to eql("<% if true %>\nabc\n<% end %>")

      result = subject.format("<% a(true) do %>\nabc\n<% end %>")
      expect(result).to eql("<% a(true) do %>\nabc\n<% end %>")

      result = subject.format("<% a(nil) { %>\nabc\n<% } %>")
      expect(result).to eql("<% a(nil) { %>\nabc\n<% } %>")
    end

    it "formats standalone 'yield'" do
      result = subject.format("<%=yield%>")
      expect(result).to eql("<%= yield %>")
    end

    it "formats standalone 'yield' with arguments" do
      result = subject.format("<%=yield x,y%>")
      expect(result).to eql("<%= yield x, y %>")
    end

    it "formats standalone 'yield' with arguments and parens" do
      result = subject.format("<%=yield(x,y)%>")
      expect(result).to eql("<%= yield(x, y) %>")
    end

    it "handles native erb comments" do
      result = subject.format("<%# locals: (item:, variant:) %>")
      expect(result).to eql("<%# locals: (item:, variant:) %>")
    end

    it "handles ruby comments" do
      result = subject.format("<% # TODO: fix this later %>")
      expect(result).to eql("<% # TODO: fix this later %>")
    end

    it 'handles case/when expression' do
      result = subject.format(<<~ERB)
        <% case a+b %>
        <% when c %>
        <%= d+e %>
        <% end %>
      ERB
      expect(result).to eql(<<~ERB)
        <% case a + b %>
        <% when c %>
        <%= d + e %>
        <% end %>
      ERB
    end
  end
end
