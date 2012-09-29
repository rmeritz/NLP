#!/usr/bin/env ruby
require_relative '../lib/interactive_encoder_classes.rb'

identity_callback = lambda { |x| x }
class <<identity_callback
  def run(&block)
    block.call(self)
  end
end

io_callbacks = CallbacksTable.new(EnglishEncoderIO.new($stdin, $stdout),
                                  'swedish' =>
                                  SwedishEncoderIO.new($stdin, $stdout))

i = EncoderInteraction.new(ARGV, io_callbacks)

i.run(CallbacksTable.new(MissingEncoder.new(i.io_obj),
                        'identity' => identity_callback,
                        'rot13' => Rot13Encoder.new))
