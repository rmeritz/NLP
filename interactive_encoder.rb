#!/usr/bin/env ruby
load 'interactive_encoder_classes.rb'
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
