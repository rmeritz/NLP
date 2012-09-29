require_relative '../lib/interactive_encoder_classes.rb'
require_relative 'interactive_encoder_mocks.rb'
require 'test/unit'

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

class EncoderInteractionTests < Test::Unit::TestCase
  def setup
    @io = MockEncoderIO.new('TestWord')
    @io_callbacks = MockCallbacksTable.new(@io)
    @encoder = MockCallback.new
    @encoder_callbacks = MockCallbacksTable.new(@encoder)
  end
  def test_with_argv
    i = EncoderInteraction.new(%w(user_encoding user_lang), @io_callbacks)
    assert(@io_callbacks.was_called_with?('user_lang'),
           "Was actually called with #{@io_callbacks.callback_name}")
    i.run(@encoder_callbacks)
    assert(@encoder_callbacks.was_called_with?('user_encoding'),
           "Was actually called with #{@encoder_callbacks.callback_name}")
  end
  def test_without_argv
    i = EncoderInteraction.new([], @io_callbacks)
    assert(@io_callbacks.was_called_with?(nil),
           "Was actually called with #{@io_callbacks.callback_name}")
    i.run(@encoder_callbacks)
    assert(@encoder_callbacks.was_called_with?('identity'),
           "Was actually called with #{@encoder_callbacks.callback_name}")
  end
  def test_run
    i = EncoderInteraction.new([], @io_callbacks).run(@encoder_callbacks)
    assert(@io.call_list_is?(:prompt, :gets, :puts),
           "Instead called #{@io.call_list}")
    assert(@io.has_put?('Called TestWord'),
           "Actually put #{@io.has_put}")
  end
end
