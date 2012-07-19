#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

### The Porter Stemmer

input_word = ARGV.first.downcase

m=input_word.
  gsub(/[^aeiouy]/, 'C').
  gsub(/[aeiou]/, 'V').
  gsub(/Cy/, 'CV').
  gsub(/y/, 'C').
  squeeze.
  gsub(/^C/, '').
  gsub(/V$/, '').
  length/2

puts m

stem_1a=input_word.
  gsub(/sses$/, 'ss').
  gsub(/ies$/, 'i').
  gsub(/([^s])s$/, '\1')

puts stem_1a
