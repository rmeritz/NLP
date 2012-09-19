load 'interactive_encoder_classes.rb'
load 'interactive_encoder_mocks.rb'
require 'test/unit'
require 'bourne'

class LangaugeEncoderIOTests < Test::Unit::TestCase
  def test_language_encoder_interface
    assert_language_encoder_interface(EnglishEncoderIO)
    assert_language_encoder_interface(SwedishEncoderIO)
  end
  def assert_language_encoder_interface(klass)
    stdio_mock = MockStdIO.new('g')
    k = klass.new(stdio_mock, stdio_mock)
    assert_match(/.*: /, k.prompt)
    assert_match(/.*: x/, k.missing_callback('x'))
    assert_equal('g', k.gets)
    assert_equal('s', k.puts('s'))
    assert_respond_to(k, :key=)
    assert_respond_to(k, :enter_the_text)
    assert_respond_to(k, :no_such_encoder)
  end
end

## Mock Callbacks and MockMissingCallback Class
class CallbacksTableTests < Test::Unit::TestCase
   def test_missing_callback
     callbacks = table(Hash.new)
     assert_instance_of_default(callbacks.object('Nonexistant Callback'))
     assert_instance_of_default(callbacks.object(nil))
   end
   def test_working_callback
     callbacks = table('Callback' => MockCallback.new)
     assert_instance_of_selected(callbacks.object('Callback'))
     assert_instance_of_default(callbacks.object('Nonexistant Callback'))
   end
   def assert_instance_of_default(obj)
     assert_instance_of(MockMissingClassback, obj)
   end
   def assert_instance_of_selected(obj)
     assert_instance_of(MockCallback, obj)
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

class EncoderInteractionTests < Test::Unit::TestCase
  def setup
    @callbacks_table = MockCallbacksTable.new(MockCallback.new)
    @io = MockEncoderIO.new('TestWord')
  end
  
  def test_new_interaction
    Interaction.new([], @io, default: 'mock_callback').
      run(@callbacks_table)

    assert(@callbacks_table.has_been_called_with?('mock_callback'))
    assert(@io.call_list_is?(:set_lang, :prompt, :gets, :puts),
           "Instead called #{@io.call_list}")
    assert(@io.has_put?('Called TestWord'),
           "Actually put #{@io.has_put}")
  end

  def test_interaction_using_argv
    argv = %w(user_encoding user_lang)

    Interaction.new(argv, @io, :default => '').run(@callbacks_table)
    
    assert(@callbacks_table.has_been_called_with?('user_encoding'),
           "The real callback is #{@callbacks_table.was_called_on}")
    assert(@io.has_lang?('user_lang'))
  end
end
