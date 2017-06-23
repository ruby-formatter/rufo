require "spec_helper"

RSpec.describe Rufo::Backport do
  it "chunks while" do
    result = Rufo::Backport.chunk_while([1, 2, 3, 5, 7, 8, 9]) { |x, y| x + 1 == y }
    expect(result).to eq([[1, 2, 3], [5], [7, 8, 9]])
  end

  it "chunks while single" do
    result = Rufo::Backport.chunk_while([1]) { |x, y| x + 1 == y }
    expect(result).to eq([[1]])
  end

  it "chunks while empty" do
    result = Rufo::Backport.chunk_while([]) { |x, y| x + 1 == y }
    expect(result).to eq([])
  end
end
