# frozen_string_literal: true

module Rufo::Backport
  # Implement Enumerable#chunk_while
  # if it's not available in the current Ruby version
  def self.chunk_while(array)
    results = []
    current = []
    first = true
    last = nil

    array.each do |elem|
      if first
        current << elem
        first = false
      else
        if yield(last, elem)
          current << elem
        else
          results << current
          current = [elem]
        end
      end
      last = elem
    end

    results << current unless current.empty?

    results
  end
end
