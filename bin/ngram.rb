#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

## N-Grams

class Gram
  attr_reader :gram
  def initialize(gram)
    @gram = gram
  end
  def n
    @gram.length
  end
  def word
    @gram.first
  end
  def history
    @gram.drop(1)
  end
  def phrase
    array =self.history << self.word
    array.join(' ')
  end
end

class Corpus
  attr_reader :file
  def initialize(file, tokenizer)
    @file = file
    @file_contents = File.read(@file)
    @tokens = tokenizer.tokens(@file_contents)
  end
  def count_word(gram)
    @tokens.count(gram.word)
  end
  def count_gram(gram)
    text = @tokens.join(' ')
    text.scan(/#{gram.phrase}/).size
  end
end

class Tokenizer
  attr_reader :tokenizer
  def initialize(tokenizer)
    @tokenizer = tokenizer.to_sym
  end
  def tokens(string)
    send(@tokenizer, string)
  end

  private
  def basic_white_space(string)
    string.split(/\s+/)
  end
end

class Probablity
  def initialize(tokenizer, source, gram)
    @tokenizer = Tokenizer.new(tokenizer)
    @corpus = Corpus.new(source, @tokenizer)
    @gram = Gram.new(gram)
  end
 def simple_unsmoothed
   gram_count = @corpus.count_gram(@gram)
   word_count = @corpus.count_word(@gram)
   p = gram_count/word_count
   pretty_print('simple unsmoothed', p)
  end

 private
 def pretty_print(method, p)
   puts "The #{method} probablity for the #{@gram.n}-gram " +
     "\"#{@gram.gram.join(' ')}\" in the corpus from #{@corpus.file} " +
     "parsed with the tokenizer #{@tokenizer.tokenizer} is" +
     " #{p}. That means there is a #{p*100}% chance that the word " +
     "\"#{@gram.word}\" would follow the words \"#{@gram.history}\"."
 end
end

input_tokenizer = ARGV[0]
input_file = ARGV[1]
input_gram = ARGV[2..-1]

Probablity.new(input_tokenizer, input_file, input_gram).simple_unsmoothed
