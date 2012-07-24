#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

### The Porter Stemmer

input_word = ARGV.first.downcase

def cv(word)
  word.gsub(/[^aeiouy]/, 'C').
    gsub(/[aeiou]/, 'V').
    gsub(/Cy/, 'CV').
    gsub(/y/, 'C')
end

puts cv(input_word)

def m(word)
  cv(word).squeeze.gsub(/^C/, '').gsub(/V$/, '').length/2
end

puts m(input_word)

def contains_vowel(stem)
  /V/ =~ cv(stem)
end

puts contains_vowel(input_word)

def ends_with_double_consonant(stem)
  /CC$/ =~ cv(stem)
end

puts ends_with_double_consonant(input_word)

def o_star_rule(stem)
  /CVC$/ =~ cv(stem) and /[^wxy]$/ =~ stem
end

puts o_star_rule(input_word)

def simple_subsitute_step(pattern, replacement)
  [ lambda { | word | pattern =~ word },
    lambda { | word | word.gsub(pattern, replacement) }
  ]
end

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

def step1b_step(regex)

  steps1b_ext=[ simple_subsitute_step(/at$/, 'ate'),
                simple_subsitute_step(/bl$/, 'ble'),
                simple_subsitute_step(/iz$/, 'ize'),
                [ lambda { | word | ends_with_double_consonant(word) and
                    /[^lsz]$/ =~ word },
                  lambda { | word | word.chop }],
                [ lambda { | word | m(word) == 1 and o_star_rule(word) },
                  lambda { | word | word+'e' }]
              ]
  
  [ lambda { | word | contains_vowel(word.gsub(regex, '')) and
      regex =~ word },
    lambda { | word | maybe_apply_next_step(steps1b_ext,
                                            word.gsub(regex, ''))}]
end

def porter_stem(word)

  steps1a=[ simple_subsitute_step(/sses$/, 'ss'),
            simple_subsitute_step(/ies$/, 'i'),
            simple_subsitute_step(/ss$/, 'ss'),
            simple_subsitute_step(/s$/, '')
          ]
  
  steps1b=[[ lambda { | word | m(word.gsub(/eed$/, 'ee')) > 0 and 
               /eed$/ =~ word },
             lambda { | word | word.gsub(/eed$/, 'ee')}],
           step1b_step(/ed$/),
           step1b_step(/ing$/)
          ]

  [steps1a, steps1b].inject(word) { | word , steps |
    maybe_apply_next_step(steps, word) }
end

puts porter_stem(input_word)
