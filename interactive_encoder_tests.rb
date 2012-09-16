load 'interactive_encoder_classes.rb'
require 'test/unit'

class InteractionTests < Test::Unit::TestCase
   def tests
   end
 end

class CallbacksTableTests < Test::Unit::TestCase
  def tests
    missing_callback_test
    working_callback_test
  end
  
   def missing_callback_test
     callbacks = table(Hash.new)
     assert_equal(callbacks.run_on('Nonexistant Callback'),
                  'Ran on mock missing callback')
   end

   def working_callback_test
     callbacks = table('WorkingCallback' => MockCallback.new)
     assert_equal(callbacks.run_on('WorkingCallback'),
                  'Ran on mock callback')
     assert_equal(callbacks.run_on('Nonexistant Callback'),
                  'Ran on mock missing callback')
   end

   def table(hash)
     CallbacksTable.new(MockMissingClassback.new(), hash)
   end
end

class EncoderTests < Test::Unit::TestCase
  def setup
    @testword = 'TestWord'
    @block = lambda {|encoder| encoder.call(@testword)}
  end

  def tests
    rot13_tests
  end

  def rot13_tests
    assert_equal(Rot13Encoder.new.run(&@block) , 'TrstWorq')
    assert_not_equal(Rot13Encoder.new.run(&@block) , @testword)
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

class MockCallback
  attr_writer :key
  def run(&block)
    'Ran on mock callback'
  end
end

class MockMissingClassback
  attr_writer :key
  def run(&block)
    'Ran on mock missing callback'
  end
end
