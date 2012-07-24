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

def simple_subsitute_step(pattern, replacement)
  [ lambda { | word | pattern =~ word },
    lambda { | word | word.gsub(pattern, replacement) }
  ]
end

steps_1a=[ simple_subsitute_step(/sses$/, 'ss'),
           simple_subsitute_step(/ies$/, 'i'),
           simple_subsitute_step(/ss$/, 'ss'),
           simple_subsitute_step(/s$/, ''),
         ]
 
puts steps_1a

def maybe_apply_next_step(steps, word)
  if steps.empty?
    word
  else if steps.first.first.call(word)
         steps.first.last.call(word)
       else
         maybe_apply_next_step(steps.drop(1), word)
       end
  end
end

puts maybe_apply_next_step(steps_1a, input_word)
