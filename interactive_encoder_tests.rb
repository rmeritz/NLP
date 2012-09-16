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

class InteractionTests < Test::Unit::TestCase
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

class MockCallbacksTable
  attr_reader :was_called_on
  def initialize(callback)
    @was_called_on = []
    @callback = callback
  end
  def run_on(callback_name, &block)
    @was_called_on << callback_name
    block.call(@callback)
  end
  def has_been_called_with?(callback_name)
   @was_called_on.include?(callback_name)
  end
end

class MockEncoderIO
  attr_reader :call_list, :has_put
  def initialize(word='default_word')
    @word = word
    @call_list = []
  end
  def set_lang(lang)
    @call_list << :set_lang
    @lang = lang
    self
  end
  def gets
    @call_list << :gets
    @word
  end
  def puts(a)
    @call_list << :puts
    @has_put = a
  end
  def prompt
    @call_list << :prompt
  end
  def call_list_is?(*call_list)
    @call_list == call_list
  end
  def has_put?(x)
    x == @has_put
  end
  def has_lang?(lang)
    lang == @lang
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
