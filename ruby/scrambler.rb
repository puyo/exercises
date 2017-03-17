#!/usr/bin/env ruby

module Scrambler
  WORD = /\w+/
  LETTER = /[A-Za-z]/

  def self.scramble(string)
    string.gsub(WORD) do |word|
      # Collect indices of scramblable letters.
      indices = []
      word.split(//).each_with_index do |character, index|
        indices << index if character =~ LETTER
      end

      # Remove 1st and last index.
      indices.shift; indices.pop

      # Jumble the letters at these indices.
      indices.each do |i|
        # Swap the letter at this index with the letter at a
        # random index.
        swap_i = indices[rand(indices.size)]
        word[i], word[swap_i] = word[swap_i], word[i]
      end

      # Evaluate to the word.
      word
    end
  end
end

while line = ARGF.gets
  puts Scrambler.scramble(line)
end

