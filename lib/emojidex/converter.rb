require 'emojidex/converters'

module Emojidex
  # Converter utility for emojidex
  class Converter
    @@size_types = { ldpi: 9, mdpi: 18, hdpi: 27, xhdpi: 36, px8: 8,
                   px16: 16, px32: 32, px64: 64, px128: 128, px256: 256 }
    @@format_types = { svg: Emojidex::Converters::SVG, png: Emojidex::Converters::PNG }

    def self.size_types
      @@size_types
    end

    def self.format_types
      @@format_types
    end

    attr_accessor :sizes, :formats, :location
    def initialize(override = {})
      @sizes = override[:sizes] || @@size_types
      @formats = override[:formats] || @@format_types
      @path = File.expand_path(override[:destination] || ENV['EMOJI_CACHE'] || './')
    end

    def convert(emoji)
    end
  end
end
