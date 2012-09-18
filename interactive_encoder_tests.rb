load 'interactive_encoder_classes.rb'
load 'interactive_encoder_mocks.rb'
require 'test/unit'

class EncoderIOTests < Test::Unit::TestCase
  def tests
    e = EncoderIO.new(MockStdIO.new('g'), MockStdIO.new('g'))
    assert_equal(e.prompt, 'Enter the text: ')
    assert_equal(e.missing_callback('x'), 'No such encoder: x')
    assert_equal(e.gets, 'g')
    assert_equal(e.puts('s'), 's')
    assert_equal(e.lang_encoder.class, EnglishEncoderIO)
    assert_equal(e.set_lang('english').lang_encoder.class,
                 EnglishEncoderIO)
    assert_equal(e.set_lang('swedish').lang_encoder.class,
                 SwedishEncoderIO)
    assert_equal(e.set_lang('unsupported lang').lang_encoder.class,
                 EnglishEncoderIO)
  end
end

class LangEncoderTests < Test::Unit::TestCase
  def test_interface
     [EnglishEncoderIO, SwedishEncoderIO].each do |klass|
       k = klass.new()
       assert_respond_to(k, :enter_the_text)
       assert_respond_to(k, :no_such_encoder)
     end
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

class LangEncoderTests < Test::Unit::TestCase
  def test_interface
     [EnglishEncoderIO, SwedishEncoderIO].each do |klass|
       k = klass.new()
       assert_respond_to(k, :enter_the_text)
       assert_respond_to(k, :no_such_encoder)
     end
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

class LangEncoderTests < Test::Unit::TestCase
  def test_interface
     [EnglishEncoderIO, SwedishEncoderIO].each do |klass|
       k = klass.new()
       assert_respond_to(k, :enter_the_text)
       assert_respond_to(k, :no_such_encoder)
     end
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
