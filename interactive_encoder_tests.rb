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
     assert_instance_of(MockDefaultCallback, obj)
   end
   def assert_instance_of_selected(obj)
     assert_instance_of(MockCallback, obj)
   end
   def table(hash)
     CallbacksTable.new(MockDefaultCallback.new(), hash)
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

## This test is much less powerful that before...
## CallbackTable clones our mock objects before using the so they are
## not accessable. Need to change EncoderInteraction so take mock
## callback table so can avoid this behavoir and objects can 
## be more directly examined.
class EncoderInteractionTests < Test::Unit::TestCase
  def setup
    @selected_encoder_name = 'mock_callback'
    @encoder_hash = {@selected_encoder_name => MockCallback.new}
    io = MockEncoderIO.new
    @io_selected_name = 'lang'
    @io_table = CallbacksTable.new(io, {@io_selected_name => io})
  end
  
  def tests
    assert_mock_encoder_callback_is_called([@selected_encoder_name])
    assert_mock_encoder_callback_is_called([@selected_encoder_name,
                                            @io_selected_name])
  end
  
  def assert_mock_encoder_callback_is_called(argv)
    assert_equal('Ran on mock callback', interaction(argv))
  end
  def interaction(argv)
    EncoderInteraction.new(argv, @io_table).run(@encoder_hash)
  end
end
