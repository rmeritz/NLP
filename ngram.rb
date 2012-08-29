#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

## N-Grams

class Gram
  def initalize(gram)
    @tokens = gram.tokenize
  end
  def n
    @tokens.count
  end
  def word
    @tokens.take(1)
  end
  def history
    @tokens.drop(1)
  end
end

class Corpus
  def initilize(source)
    string = File.read(source)
    @tokens = string.tokenize
  end
  def count(gram)
    
  end

  private 
  def is_match(gram, tokens, bool)
    matching = gram.word
    rest = gram.history
    match_index = tokens.find_index(matching)
    case match_index
      when nil then bool
      else 
    boolean, rest_of_tokens
  end
end


class Probablity
  def initalize(source, gram)
    @corpus = Corpus.new(source)
    @gram = Gram.new(gram)
  end
  def simple_unsmoothed
    @corpus.count(@gram)/@corpus.count(@gram.word)
 end
end

source = ARGV[0]
gram = ARGV[1]

probablity = Probablity.new(source, gram)

puts probablity.simple_unsmoothed
