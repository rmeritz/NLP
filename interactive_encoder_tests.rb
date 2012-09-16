load 'interactive_encoder_classes.rb'
require 'test/unit'

# class InteractionTests < Test::Unit::TestCase
#   def tests
#   end
# end

# class InteractionTests < Test::Unit::TestCase
#   def tests
#   end
# end

testword = 'TestWord'
block = lambda {|callback| callback.call(testword)}

class EncoderTest < Test::Unit::TestCase
  def tests
    testword = 'TestWord'
    block = lambda {|callback| callback.call(testword)}
    assert_equal(Rot13Encoder.new.run(&block) , 'TrstWorq')
    assert_not_equal(Rot13Encoder.new.run(&block) , testword)
  end
end

# class MockCallbacksTable
#   def initialize(default_obj, callbacks_table)# -*- coding: utf-8 -*-


#     @callbacks_table = build_callbacks_table(callbacks_table, default_obj)
#   end
#  def run_on(callback_name, &block)
#     callback = @callbacks_table[callback_name]
#     callback.run(&block)
#   end
# end

# class MockEncoderIO
#   def set_lang(lang)
#     self
#   end
#   def gets(*a)
#     'TestWord'
#   end
#   def puts(*a)
#   end
#   def prompt
#   end
# end
