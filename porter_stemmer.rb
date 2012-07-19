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

steps_1a=[ /sses$/, 'ss',
           /ies$/, 'i',
           /ss$/, 'ss',
           /s$/, '']
 
puts steps_1a

def maybe_apply_next_step(steps, word)
  if steps.empty?
    word
  else if steps.fetch(0) =~ word
         word.gsub(steps.fetch(0), steps.fetch(1))
       else
         maybe_apply_next_step(steps, word)
       end
  end
end

puts maybe_apply_next_step(steps_1a, input_word)
