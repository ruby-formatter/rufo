require 'spec_helper'

RSpec.describe Rufo::DocBuilder do
  it 'allows valid documents to be created' do
    parts = ["something", {type: :symbol_yo}]
    expect(described_class.concat(parts)).to eql({
      type: :concat,
      parts: parts,
    })
  end

  it 'raises an error if a document is not the correct type' do
    invalid_docs = [
      [],
      1,
      {},
      {type: "string"},
    ]
    invalid_docs.each do |doc|
      expect { described_class.concat([doc]) }.to raise_error(
        Rufo::DocBuilder::InvalidDocError
      )
    end
  end
end
