require 'phantom_svg'
require_relative 'preprocessor'

module Emojidex
  # Converter utility for emojidex
  class Converter
    def self.default_sizes
      { ldpi: 9, mdpi: 18, hdpi: 27, xhdpi: 36, px8: 8,
        px16: 16, px32: 32, px64: 64, px128: 128, px256: 256 }
    end

    attr_accessor :sizes, :destination
    def initialize(override = {})
      @sizes = override[:sizes] || Converter.default_sizes
      @destination = File.expand_path(override[:destination] || ENV['EMOJI_CACHE'] || './')
      @noisy = override[:noisy] || :false
    end

    def rasterize(emoji, source_dir)
      emoji.each do |moji|
        phantom_svg = Phantom::SVG::Base.new("#{source_dir}/#{moji.code}.svg")
        @sizes.each do |key, val|
          # Create out directory.
          out_dir = "#{@destination}/#{key}"
          FileUtils.mkdir_p(out_dir)

          # Set size.
          phantom_svg.width = phantom_svg.height = val.to_i

          # Output png.
          puts "Converting: #{out_dir}/#{moji.code}.png" if @noisy
          phantom_svg.save_apng("#{out_dir}/#{moji.code}.png")
        end
      end
    end

    def rasterize_collection(collection)
      rasterize(collection.emoji.values, collection.source_path)
      collection.cache_index @destination
    end

    def preprocess(path)
      preprocessor = Emojidex::Preprocessor.new
      preprocessor.compile_svg_animations(path)
    end
  end
end
