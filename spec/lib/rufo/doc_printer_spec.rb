require 'spec_helper'

RSpec.describe Rufo::DocPrinter do
  B = Rufo::DocBuilder

  def print(doc, options = nil)
    print_doc(doc, options)[:formatted]
  end

  def print_doc(doc, options = nil)
    options ||= {}
    options = {print_width: 80}.merge!(options)
    described_class.print_doc_to_string(doc, options)
  end

  it 'prints concatenations' do
    doc = B.concat(["a", " = ", "1"])
    expect(print(doc)).to eql("a = 1")
  end

  it 'prints lines' do
    doc = B.group(B.concat(["asd", B::LINE, "123"]))
    expect(print(doc)).to eql("asd 123")
    expect(print(doc, print_width: 4)).to eql("asd\n123")
    expect(print(doc, print_width: 2)).to eql("asd\n123")
  end

  it 'prints soft lines' do
    doc = B.group(B.concat(["asd", B::SOFT_LINE, "123"]))
    expect(print(doc)).to eql("asd123")
    expect(print(doc, print_width: 4)).to eql("asd\n123")
  end

  it 'prints hard lines' do
    doc = B.group(B.concat(["asd", B::HARD_LINE, "123"]))
    expect(print(doc)).to eql("asd\n123")
    expect(print(doc, print_width: 4)).to eql("asd\n123")
  end

  it 'prints literal lines' do
    doc = B.group(B.concat(["asd", B::LITERAL_LINE, "123"]))
    expect(print(doc)).to eql("asd\n123")
    expect(print(doc, print_width: 4)).to eql("asd\n123")
  end

  it 'prints indents' do
    doc = B.indent(B.concat([B::HARD_LINE, "abc123"]))
    expect(print(doc)).to eql("\n  abc123")
  end

  it 'does not print indents for literal lines' do
    doc = B.indent(B.concat([B::LITERAL_LINE, "abc123"]))
    expect(print(doc)).to eql("\nabc123")
  end

  it "prints alignments" do
    doc = B.align(1, B.concat([B::HARD_LINE, "abc123"]))
    expect(print(doc)).to eql("\n abc123")
  end

  describe "printing of groups" do
    it 'prints simple groups' do
      doc = B.group(B.concat(["asd", B::SOFT_LINE, "123"]))
      expect(print(doc)).to eql('asd123')
    end

    it 'prints groups that should break' do
      doc = B.group(B.concat(["asd", B::SOFT_LINE, "123"]), should_break: true)
      expect(print(doc)).to eql("asd\n123")
    end
  end

  it "prints conditional groups" do
    doc_states = B.conditional_group([B.concat(["asd"]), B.concat(["as"])])
    expect(print(doc_states)).to eql("asd")
    expect(print(doc_states, print_width: 2)).to eql("as")
  end

  it "prints fill" do
    doc = B.fill(["asd", B::LINE, "123", B::LINE, "qwe"])
    expect(print(doc)).to eql("asd 123 qwe")
    expect(print(doc, print_width: 8)).to eql("asd 123\nqwe")
    expect(print(doc, print_width: 4)).to eql("asd\n123\nqwe")
  end

  it "prints line suffixes" do
    doc = B.concat(["asd", B.line_suffix("qwe"), "123", B::HARD_LINE])
    expect(print(doc)).to eql("asd123qwe\n")
  end

  it "prints joins" do
    doc = B.join(", ", ["asd", "123"])
    expect(print(doc)).to eql("asd, 123")
  end

  it "prints cursor positions" do
    doc = B.concat(["asd", B::CURSOR, "123"])
    expect(print_doc(doc)).to eql(formatted: "asd123", cursor: 3)
  end

  context "array expression" do
    let(:code_filled) {
      <<~CODE.chomp("\n")
        [1, 2, 3, 4, 5]
      CODE
    }
    let(:code_broken) {
      <<~CODE.chomp("\n")
        [
          1,
          2,
          3,
          4,
          5,
        ]
      CODE
    }

    let(:doc) {
      B.group(
        B.concat([
          "[",
          B.indent(
            B.concat([
              B::SOFT_LINE,
              B.join(
                B.concat([",", B::LINE]),
                ["1", "2", "3", "4", B.concat(["5", B.if_break(",", "")])]
              ),
            ])
          ),
          B::SOFT_LINE,
          "]",
        ])
      )
    }

    it 'formats correctly' do
      expect(print(doc, print_width: 10)).to eql(code_broken)
      expect(print(doc, print_width: 80)).to eql(code_filled)
    end
  end

  context 'array with comment' do
    let(:doc) {
      B.group(
        B.concat([
          "[",
          B.indent(
            B.concat([
              B::SOFT_LINE,
              B.join(
                B.concat([",", B::LINE]),
                [B.concat(["1", B.line_suffix(' # a comment'), B::LINE_SUFFIX_BOUNDARY])]
              ),
            ])
          ),
          B::SOFT_LINE,
          "]",
        ]),
        should_break: true
      )
    }

    it 'formats array with comment' do
      expect(print(doc, print_width: 80)).to eql(<<~CODE.chomp("\n")
        [
          1 # a comment
        ]
      CODE
      )
    end
  end
end
