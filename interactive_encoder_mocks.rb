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

class MockStdIO
  def initialize(gotten)
    @gotten = gotten
  end
  def gets
    @gotten
  end
  def puts(thing)
    thing
  end
  def print(string)
    string
  end
end
