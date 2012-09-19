#!/usr/bin/env ruby
load 'interactive_encoder_classes.rb'

identity_callback = lambda { |x| x }
class <<identity_callback
  def run(&block)
    block.call(self)
  end
end

def new_io(klass)
  klass.new($stdin, $stdout)
end

english_io = new_io(EnglishEncoderIO)

languages = {'english' => english_io,
  'swedish' => new_io(SwedishEncoderIO)}

io_callbacks_table = CallbacksTable.new(english_io, languages)

interaction = EncoderInteraction.new(ARGV, io_callbacks_table)

interaction.run({'identity' => identity_callback,
                  'rot13' => Rot13Encoder.new})
                
