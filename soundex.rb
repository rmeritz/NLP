#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

## The Soundex Algorithim - A phonetic algorithim

### Tries to encode homophones with the same representation.
### Produces a four-character strings composed.
### A single letter followed by three numbers.

require 'rubygems'

name = ARGV.first

first_letter=name[0,1].capitalize

rest=name[1..-1].delete "ehiouwy"

rest.gsub!(/[bfpv]/, '1')
rest.gsub!(/[cgjkqsxz]/, '2')
rest.gsub!(/[dt]/, '3')
rest.gsub!(/[l]/, '4')
rest.gsub!(/[mn]/, '5')
rest.gsub!(/[r]/, '6')

puts 
 

