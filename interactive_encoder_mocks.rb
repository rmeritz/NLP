class MockCallbacksTable
  attr_reader :callback_name
  def initialize(object)
    @object = object
  end
  def object(callback_name)
    @callback_name = callback_name
    @object
  end
  def was_called_with?(callback_name)
    callback_name == @callback_name
  end
end

class MockEncoderIO
  attr_reader :call_list, :has_put
  def initialize(word='default_word')
    @word = word
    @call_list = []
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
end

class MockDefaultCallback
  attr_writer :key
end

class MockCallback
  def run(&block)
     block.call(self)
  end
  def call(thing)
    "Called #{thing}"
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
