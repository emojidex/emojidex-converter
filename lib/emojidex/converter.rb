require 'emojidex'
require 'phantom_svg'
require_relative 'preprocessor'

module Emojidex
  # Converter utility for emojidex
  class Converter
    attr_accessor :sizes, :destination, :last_run_time

    def initialize(override = {})
      @sizes = override[:sizes] || Emojidex::Defaults.sizes
      @destination = File.expand_path(override[:destination] || ENV['EMOJI_CACHE'] || './')
      @noisy = override[:noisy] || false
    end

    def rasterize(emoji, source_dir)
      _create_output_paths

      start_time = Time.now
      emoji.each do |moji|
        puts "Source: #{source_dir}/#{moji.code}.svg" if @noisy
        render_threads = []
        @sizes.each do |key, val|
          render_threads << Thread.new do
            out_dir = "#{@destination}/#{key}"
            phantom_svg = Phantom::SVG::Base.new("#{source_dir}/#{moji.code}.svg")
            # Set size.
            phantom_svg.width = phantom_svg.height = val.to_i
            # Render PNGs
            puts "Converting: #{out_dir}/#{moji.code}.png" if @noisy
            phantom_svg.save_apng("#{out_dir}/#{moji.code}.png")
            phantom_svg.reset
            phantom_svg = nil
            moji.paths[:png][key] = "#{out_dir}/#{moji.code}.png" 
          end
        end
        render_threads.each { |th| th.join }
        GC.start
      end

      run_time = Time.now - start_time
      puts "Total Converstion Time: #{run_time}" if @noisy
      @last_run_time = run_time
    end

    def rasterize_collection(collection)
      rasterize(collection.emoji.values, collection.source_path)
      collection.generate_checksums
      puts "Rasterization completed. Writing index." if @noisy
      collection.write_index @destination
      
      puts "Re-opening collection at #{@destination} to generate meta data" if @noisy
      converted_collection = Emojidex::Data::Collection.new(local_load_path: @destination)
      converted_collection.raster_source_path = @destination
      converted_collection.generate_paths

      puts "Generating checksums..." if @noisy
      converted_collection.generate_checksums

      puts "Checksums generated. Writing index to emoji.json..." if @noisy
      converted_collection.write_index @destination
      converted_collection
    end

    def preprocess(path)
      preprocessor = Emojidex::Preprocessor.new
      preprocessor.compile_svg_animations(path)
    end

    private

    def _create_output_paths
      @sizes.each do |key, _val|
        out_dir = "#{@destination}/#{key}"
        puts "*Clearning #{@destination}/#{key}" if @noisy
        FileUtils.rm_rf(out_dir)
        puts "*Creating #{@destination}/#{key}" if @noisy
        FileUtils.mkdir_p(out_dir)
      end
    end
  end
end
