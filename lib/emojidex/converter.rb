# require 'emojidex/converters'
# require 'emojidex/collection'
require_relative 'converters'
require_relative 'collection'

module Emojidex
  # Converter utility for emojidex
  class Converter
    def self.default_sizes
      { ldpi: 9, mdpi: 18, hdpi: 27, xhdpi: 36, px8: 8,
        px16: 16, px32: 32, px64: 64, px128: 128, px256: 256 }
    end

    def self.default_formats
      { svg: Emojidex::Converters::SVG, png: Emojidex::Converters::PNG }
    end

    attr_accessor :sizes, :formats, :location
    def initialize(override = {})
      @sizes = override[:sizes] || Converter.default_sizes
      @formats = override[:formats] || Converter.default_formats
      @path = File.expand_path(override[:destination] || ENV['EMOJI_CACHE'] || './')
    end

    def convert(emoji, source_dir)
      if File.directory?("#{source_dir}/#{emoji.code}")
        png = Emojidex::Converters::PNG.new
        png.convert_to_apng(emoji.code, @sizes, source_dir)
      else
        svg = Emojidex::Converters::SVG.new
        svg.convert_to_png(emoji.code, @sizes, source_dir)
      end
    end
  end
end
