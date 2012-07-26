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

def measure(word)
  cv(word).squeeze.gsub(/^C/, '').gsub(/V$/, '').length/2
end  

def m(word, pattern)
  measure(word.gsub(pattern, ''))
end

def contains_vowel(stem)
  /V/ =~ cv(stem)
end

def ends_with_double_consonant(stem)
  /CC$/ =~ cv(stem)
end

def o_star_rule(stem)
  /CVC$/ =~ cv(stem) and /[^wxy]$/ =~ stem
end

def lambda_subsitute(pattern, replacement)
  lambda { | word | word.gsub(pattern, replacement) }
end

def simple_subsitute_step(pattern, replacement)
  [ lambda { | word | pattern =~ word },
    lambda_subsitute(pattern, replacement)
  ]
end

def simple_m_subsitute_step(pattern, replacement, m)
  [ lambda { | word |
      m(word, pattern) > m and pattern =~ word },
  lambda_subsitute(pattern, replacement)
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
                [ lambda { | word | measure(word) == 1 and
                    o_star_rule(word) },
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

  steps1b=[ simple_m_subsitute_step(/eed$/, 'ee', 0),
            step1b_step(/ed$/),
            step1b_step(/ing$/)
          ]

  steps1c=[[ lambda { | word | contains_vowel(word.chomp('y')) },
             lambda { | word | word.gsub(/y$/, 'i') }]
          ]

  steps2=[ simple_m_subsitute_step(/ational$/, 'ate', 0),
           simple_m_subsitute_step(/tional$/, 'tion', 0),
           simple_m_subsitute_step(/enci$/, 'ence', 0),
           simple_m_subsitute_step(/anci$/, 'ance', 0),
           simple_m_subsitute_step(/izer$/, 'ize', 0),
           simple_m_subsitute_step(/abli$/, 'able', 0),
           simple_m_subsitute_step(/alli$/, 'al', 0),
           simple_m_subsitute_step(/entli$/, 'ent', 0),
           simple_m_subsitute_step(/eli$/, 'e', 0),
           simple_m_subsitute_step(/ousli$/, 'ous', 0),
           simple_m_subsitute_step(/ization$/, 'ize', 0),
           simple_m_subsitute_step(/ation$/, 'ate', 0),
           simple_m_subsitute_step(/ator$/, 'ate', 0),
           simple_m_subsitute_step(/alism$/, 'al', 0),
           simple_m_subsitute_step(/iveness$/, 'ive', 0),
           simple_m_subsitute_step(/fulness$/, 'ful', 0),
           simple_m_subsitute_step(/ousness$/, 'ous', 0),
           simple_m_subsitute_step(/aliti$/, 'al', 0),
           simple_m_subsitute_step(/iviti$/, 'ive', 0),
           simple_m_subsitute_step(/biliti/, 'ble', 0)
         ]

  steps3=[ simple_m_subsitute_step(/icate$/, 'ic', 0),
           simple_m_subsitute_step(/ative$/, '', 0),
           simple_m_subsitute_step(/alize$/, 'al', 0),
           simple_m_subsitute_step(/iciti$/, 'ic', 0),
           simple_m_subsitute_step(/ical$/, 'ic', 0),
           simple_m_subsitute_step(/ful$/, '', 0),
           simple_m_subsitute_step(/ness$/, '', 0),
          ]

  steps4=[ simple_m_subsitute_step(/al$/, '', 1),
           simple_m_subsitute_step(/ance$/, '', 1),
           simple_m_subsitute_step(/ence$/, '', 1),
           simple_m_subsitute_step(/er$/, '', 1),
           simple_m_subsitute_step(/ic$/, '', 1),
           simple_m_subsitute_step(/able$/, '', 1),
           simple_m_subsitute_step(/ible$/, '', 1),
           simple_m_subsitute_step(/ant$/, '', 1),
           simple_m_subsitute_step(/ement$/, '', 1),
           simple_m_subsitute_step(/ment$/, '', 1),
           simple_m_subsitute_step(/ent$/, '', 1),
           [ lambda { | word | m(word, /ion$/) > 1 and
               word =~ /[st]ion$/ },
             lambda_subsitute(/ion$/, '')],
           simple_m_subsitute_step(/ou$/, '', 1),
           simple_m_subsitute_step(/ism$/, '', 1),
           simple_m_subsitute_step(/ate$/, '', 1),
           simple_m_subsitute_step(/iti$/, '', 1),
           simple_m_subsitute_step(/ous$/, '', 1),
           simple_m_subsitute_step(/ive$/, '', 1),
           simple_m_subsitute_step(/ize$/, '', 1)
         ]

  all_steps=[ steps1a,
              steps1b,
              steps1c,
              steps2,
              steps3,
              steps4
            ]
  
  all_steps.inject(word) { | word , steps |
    maybe_apply_next_step(steps, word) }
  
end

puts porter_stem(input_word)
