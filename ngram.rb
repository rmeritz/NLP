#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

## N-Grams

class Gram

  attr_reader :tokens
  
  def initialize(gram)
    @tokens = gram
  end
  def n
    @tokens.length
  end
  def word
    @tokens.take(1)
  end
  def history
    @tokens.drop(1)
  end
end

class Corpus

  attr_reader :file, :tokens
  
  def initialize(file)
    @file = file
    @file_contents = File.read(@file)
    @tokens = @file_contents.split(/\s=+/)
  end
  # def count(gram)
    
  # end

  # def is_match(gram, tokens, bool)
  #   matching = gram.word
  #   rest = gram.history
  #   match_index = tokens.find_index(matching)
  #   case match_index
  #     when nil then bool
  #     else 
  #   boolean, rest_of_tokens
  # end
end


class Probablity
  
  attr_reader :corpus, :gram
  
  def initialize(source, gram)
    @corpus = Corpus.new(source)
    @gram = Gram.new(gram)
  end
#   def simple_unsmoothed
#     @corpus.count(@gram)/@corpus.count(@gram.word)
#  end
end

input_file = ARGV[0]
input_gram = ARGV[1..-1]

probablity = Probablity.new(input_file, input_gram)

# puts probablity.simple_unsmoothed

puts probablity
puts probablity.gram
puts probablity.gram.tokens
puts probablity.gram.tokens.class
puts probablity.gram.n
puts probablity.gram.word.class
puts probablity.gram.history.class
