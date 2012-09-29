# -*- coding: utf-8 -*-

class EncoderInteraction
  attr_reader :io_obj
  def initialize(argv, io_callbacks)
    @callback_name = argv[0] || 'identity'
    @io_obj = io_callbacks.object(argv[1])
  end
  def run(encodings_callbacks)
    encodings_callbacks.object(@callback_name).run do |callback|
      @io_obj.prompt
      input = @io_obj.gets
      @io_obj.puts(callback.call(input))
    end
  end
end

class CallbacksTable
  def initialize(default_obj, hash)
    @callbacks_table = build_callbacks_table(hash, default_obj)
  end
  def object(callback_name)
    callback = @callbacks_table[callback_name]
  end
  private
  def build_callbacks_table(initial_table, default_obj)
    initial_table.clone.tap do |new_table|
      new_table.default_proc = lambda do |hash, key|
        default_obj.tap {|o| o.key=(key)}
      end
    end
  end
end

class EncoderIO
  attr_writer :key #Need by default language as called by callback table
  def initialize(stdin, stdout)
    @stdin = stdin
    @stdout = stdout
  end
  def gets
    @stdin.gets
  end
  def puts(*a)
    @stdout.puts(*a)
  end
  def prompt
    @stdout.print enter_the_text + ": "
  end
  def missing_callback(callback_name)
    @stdout.puts no_such_encoder + ": #{callback_name}"
  end
end

class EnglishEncoderIO < EncoderIO
  def enter_the_text
    'Enter the text'
  end
  def no_such_encoder
    'No such encoder'
  end
end

class SwedishEncoderIO < EncoderIO
  def enter_the_text
    "Ange texten"
  end
  def no_such_encoder
    "Ingen sådan kodare"
  end
end

class MissingEncoder
  attr_writer :key
  def initialize(io)
    @io = io
    @key = nil
  end
  def run(&block)
    @io.missing_callback(@key)
  end
  def call
  end
end

class Rot13Encoder
  def run(&block)
    block.call(self)
  end
  def call(string)
    string.tr('a-m', 'n-z')
  end
end
