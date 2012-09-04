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
end

class Corpus
  attr_reader :file
  def initialize(file)
    @file = file
    @file_contents = File.read(@file)
    @tokens = @file_contents.split(/\s+/)
  end
  def count_word(gram)
    @tokens.count(gram.word)
  end
  def count_gram(gram)
    gram.gram.length #FIXME
  end
end

class Probablity
  attr_reader :corpus, :gram
  def initialize(source, gram)
    @corpus = Corpus.new(source)
    @gram = Gram.new(gram)
  end
 def simple_unsmoothed
   gram_count = @corpus.count_gram(@gram)
   puts "The gram count is #{gram_count}."
   word_count = @corpus.count_word(@gram)
   puts "The word count is #{word_count}."
   p = gram_count/word_count
   puts "The simple unsmoothed probablity for the #{@gram.n}-gram " +
     "#{@gram.gram} in the corpus from #{@corpus.file} is #{p}." +
     "That means there is a #{p*100}% chance that the word " +
     "\"#{@gram.word}\" would follow the words \"#{@gram.history}\"."
  end
end

input_file = ARGV[0]
input_gram = ARGV[1..-1]

Probablity.new(input_file, input_gram).simple_unsmoothed
