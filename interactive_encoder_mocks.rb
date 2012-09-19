class MockEncoderIO
  attr_writer :key
  def gets
  end
  def puts(a)
  end
  def prompt
  end
end

class MockDefaultCallback
  attr_writer :key
end

class MockCallback
  def run(&block)
    'Ran on mock callback'
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
