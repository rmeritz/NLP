load 'interactive_encoder_classes.rb'
require 'test/unit'

class LangEncoderTests < Test::Unit::TestCase
   def tests
     all_translation_available(EnglishEncoderIO.new())
     all_translation_available(SwedishEncoderIO.new())
   end
   def all_translation_available(test_class)
     assert_equal(test_class.enter_the_text.class, String)
     assert_equal(test_class.no_such_encoder.class, String)
   end
 end

class CallbacksTableTests < Test::Unit::TestCase
   def test_missing_callback
     callbacks = table(Hash.new)
     assert_equal(callbacks.run_on('Nonexistant Callback'),
                  'Ran on mock missing callback')
   end

   def test_working_callback
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

  def test_rot13
    assert_equal(Rot13Encoder.new.run(&@block) , 'TrstWorq')
    assert_not_equal(Rot13Encoder.new.run(&@block) , @testword)
  end
end

class InteractionTests  < Test::Unit::TestCase  
  def test_new_interaction
    callbacks_table = MockCallbacksTable.new
    interaction('mock_callback').run(callbacks_table)
    assert(callbacks_table.has_been_called_with?('mock_callback'))
  end
  def interaction(default)
    Interaction.new([], MockEncoderIO.new(), :default => default)
  end
end

class MockCallbacksTable
  def initialize
    @was_called_on = []
  end
  def run_on(callback_name, &block)
    @was_called_on << callback_name 
  end
  def has_been_called_with?(callback_name)
   @was_called_on.include?(callback_name)
  end
end

class MockEncoderIO
  def set_lang(lang)
    self
  end
  def gets(*a)
    'TestWord'
  end
  def puts(*a)
  end
  def prompt
  end
end

class MockCallback
  attr_writer :key
  def run(&block)
    'Ran on mock callback'
  end
  def call(thing)
    "Called #{thing}"
  end
end

class MockMissingClassback
  attr_writer :key
  def run(&block)
    'Ran on mock missing callback'
  end
end
