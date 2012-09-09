#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

class Interaction
  def initialize(argv, io, options)
    @callback_name = argv[0] || options[:default]
    @io = io.set_lang(argv[1])
  end

  def run(callbacks_table)
    callbacks_table.run_on(@callback_name) do |callback|
      @io.prompt
      input = @io.gets
      @io.puts(callback.call(input))
    end
  end
end

class CallbacksTable
  def initialize(default_obj, callbacks_table)
    @callbacks_table = build_callbacks_table(callbacks_table, default_obj)
  end

  def run_on(callback_name, &block)
    callback = @callbacks_table[callback_name]
    callback.run(&block)
  end

  private

  def build_callbacks_table(initial_table, default_obj)
    initial_table.clone.tap do |new_table|
      new_table.default_proc = lambda do |hash, key|
        default_obj.key(key)
      end
    end
  end
end

class EncoderIO
  def initialize
    @lang_encoder = self.default
  end

  def set_lang(lang)
    @lang_encoder = self.langs[lang] || self.default
    self
  end

  def gets(*a)
    $stdin.gets(*a)
  end

  def puts(*a)
    $stdout.puts(*a)
  end

  def prompt
    $stdout.print @lang_encoder.enter_the_text + ": "
  end

  def missing_callback(callback_name)
    $stdout.puts @lang_encoder.no_such_encoder + ": #{callback_name}"
  end

  protected
  def default
    EnglishEncoderIO.new
  end

  def langs
    {nil => self.default,
      'english' => EnglishEncoderIO.new,
      'swedish' => SwedishEncoderIO.new}
  end

end

class EnglishEncoderIO
  def enter_the_text
    'Enter the text'
  end
  def no_such_encoder
    'No such encoder'
  end
end

class SwedishEncoderIO
  def enter_the_text
    "Ange texten"
  end
  def no_such_encoder
    "Ingen sådan kodare"
  end
end

class MissingCallback
  def initialize(io)
    @io = io
    @key = nil
  end

  def key(key)
    @key = key
    self
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

# Main:

io = EncoderIO.new

identity_callback = lambda { |x| x }
class <<identity_callback
  def run(&block)
    block.call(self)
  end
end

interaction = Interaction.new(ARGV, io, :default => 'identity')
callbacks = CallbacksTable.new(MissingCallback.new(io),
                               'identity' => identity_callback,
                               'rot13' => Rot13Encoder.new)

interaction.run(callbacks)
