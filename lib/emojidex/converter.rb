# require 'emojidex/converters'
# require 'emojidex/collection'
require 'phantom_svg'
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

    def convert(emojis, source_dir)
      emojis.each do |emoji|
        phantom_svg = Phantom::SVG::Base.new("#{source_dir}/#{emoji.code}.svg")
        @sizes.each do |key, val|
          out_dir = "#{@path}/#{key}"
          FileUtils.mkdir_p(out_dir)
          phantom_svg.width = phantom_svg.height = val.to_i
          phantom_svg.save_apng("#{out_dir}/#{emoji.code}.png")
        end
      end
    end

    def preprocess(source_dir)
      preprocessor = Emojidex::Converters::Preprocessor.new
      preprocessor.compile_svg_animations(source_dir)
    end
  end
end
