require 'emojidex'
require 'phantom_svg'
require_relative 'preprocessor'

module Emojidex
  # Converter utility for emojidex
  class Converter
    attr_accessor :sizes, :destination

    def initialize(override = {})
      @sizes = override[:sizes] || Emojidex::Defaults.sizes
      @destination = File.expand_path(override[:destination] || ENV['EMOJI_CACHE'] || './')
      @noisy = override[:noisy] || :false
    end

    def rasterize(emoji, source_dir)
      _create_output_paths
      emoji.each do |moji|
        phantom_svg = Phantom::SVG::Base.new("#{source_dir}/#{moji.code}.svg")
        render_threads = []
        @sizes.each do |key, val|
          out_dir = "#{@destination}/#{key}"
          # Set size.
          phantom_svg.width = phantom_svg.height = val.to_i
          # Render PNGs
          render_threads << Thread.new do
            puts "Converting: #{out_dir}/#{moji.code}.png" if @noisy
            phantom_svg.save_apng("#{out_dir}/#{moji.code}.png")
          end
        end
        render_threads.each {|th| th.join }
        phantom_svg.reset
        GC.start
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

    private

    def _create_output_paths
      @sizes.each do |key, val|
        out_dir = "#{@destination}/#{key}"
        FileUtils.mkdir_p(out_dir)
      end
    end
  end
end
