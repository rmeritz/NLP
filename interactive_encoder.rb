#!/usr/bin/env ruby

class Interaction
  def initialize(argv, io, options)
    @callback_name = argv.first || options[:default]
    @io = io
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
  def initialize(io, callbacks_table)
    @io = io
    @callbacks_table = build_callbacks_table(callbacks_table)
  end

  def run_on(callback_name, &block)
    callback = @callbacks_table[callback_name]
    callback.run(&block)
  end

  private

  def build_callbacks_table(initial_table)
    initial_table.clone.tap do |new_table|
      new_table.default_proc = lambda do |hash, key|
        MissingCallback.new(@io, key)
      end
    end
  end
end

class EncoderIO
  def prompt
    $stdout.print "Enter the text: "
  end

  def gets(*a)
    $stdin.gets(*a)
  end

  def puts(*a)
    $stdout.puts(*a)
  end

  def missing_callback(callback_name)
    puts "No such encoder: #{callback_name}"
  end
end

class MissingCallback
  def initialize(io, key)
    @io = io
    @key = key
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
callbacks = CallbacksTable.new(io,
  'identity' => identity_callback, 'rot13' => Rot13Encoder.new)

interaction.run(callbacks)
