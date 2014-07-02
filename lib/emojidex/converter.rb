# require 'emojidex/converters'
# require 'emojidex/collection'
require_relative 'converters'
require_relative 'collection'

module Emojidex
  # Converter utility for emojidex
  class Converter
    @size_types = { ldpi: 9, mdpi: 18, hdpi: 27, xhdpi: 36, px8: 8,
                    px16: 16, px32: 32, px64: 64, px128: 128, px256: 256 }
    @format_types = { svg: Emojidex::Converters::SVG, png: Emojidex::Converters::PNG }

    attr_reader :size_types, :format_types
    attr_accessor :sizes, :formats, :location
    def initialize(override = {})
      # @sizes = override[:sizes] || @@size_types
      if override[:sizes].nil?
        @sizes = @@size_types
      else
        @sizes = {}
        sizes = override[:sizes]
        sizes.each { |value| @sizes[value] = @@size_types[value] }
      end

      @formats = override[:formats] || @@format_types
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
