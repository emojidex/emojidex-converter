require 'emojidex'
require 'phantom_svg'
require_relative 'preprocessor'

# WARNING: The following code works, but it's basically just thrown together cowboy code.
# This code may be cleaned in the future... maybe...

module Emojidex
  # Converter utility for emojidex
  class Converter
    attr_accessor :sizes, :destination, :last_run_time

    def initialize(override = {})
      @sizes = override[:sizes] || Emojidex::Defaults.sizes
      @destination = File.expand_path(override[:destination] || ENV['EMOJI_CACHE'] || './')
      @noisy = override[:noisy] || false
      @max_threads = override[:max_threads] || @sizes.length
      puts "Converting to #{@sizes.length} sizes with #{@max_threads}, outputting to #{@destination}." if @noisy
    end

    def rasterize(emoji, source_dir)
      _create_output_paths

      start_time = Time.now
      @queue = []
      @processed_count = 0
      @emoji_in_processing = []
      @source_dir = source_dir
      info_print = Thread.new do
        if @noisy
          puts "Processing..."
          full_total = emoji.length * @sizes.length
          while @processed_count < full_total
            print "\r[#{@processed_count} / #{full_total}](" +
              "#{((@processed_count.to_f / (full_total).to_f) * 100.0).to_i}%)" +
              " ⚙ \"#{@emoji_in_processing.first}\"... TC:{#{@emoji_in_processing.length}}" +
              "⌚ #{(Time.now - start_time).to_i}s\033[K"
            sleep 3
          end
        end
      end
      emoji.each do |moji|
        @sizes.each do |key, val|
          @queue << {moji: moji, size_code: key, size: val}
        end
      end

      process_queue

      info_print.join
      run_time = Time.now - start_time
      puts "Total Converstion Time: #{run_time}" if @noisy
      @last_run_time = run_time
    end

    def process_queue
      processing_threads = []
      queue_lock = Mutex.new
      @max_threads.times do
        processing_threads << Thread.new do
          while (@queue.length > 0)
            item = nil
            queue_lock.synchronize do
              item = @queue.pop if @queue.length > 0
            end
            process_item(item) if item != nil
          end
        end
      end

      processing_threads.each { |th| th.join }
      GC.start
    end

    def process_components(moji, size_code, size, out_dir)
      moji.combinations.each do |combo|
        for i in 0..(combo.components.length - 1)
          combo.components[i].each do |component|
            Dir.mkdir("#{out_dir}/#{combo.base}") unless Dir.exist? "#{out_dir}/#{combo.base}"
            Dir.mkdir("#{out_dir}/#{combo.base}/#{i}") unless Dir.exist? "#{out_dir}/#{combo.base}/#{i}"
            
            next if File.exist? "#{out_dir}/#{combo.base}/#{i}/#{component}.png"

            phantom_svg = Phantom::SVG::Base.new("#{@source_dir}/#{combo.base}/#{i}/#{component}.svg")
            phantom_svg.width = phantom_svg.height = size.to_i
            phantom_svg.save_apng("#{out_dir}/#{combo.base}/#{i}/#{component}.png")
            phantom_svg.reset
            phantom_svg = nil
          end
        end
      end
    end

    def process_item(item)
      moji = item[:moji]  
      size_code = item[:size_code]
      size = item[:size]
      processing_id = "#{moji.code}@#{size_code}"
      @emoji_in_processing << processing_id
      out_dir = "#{@destination}/#{size_code}"
      phantom_svg = Phantom::SVG::Base.new("#{@source_dir}/#{moji.code}.svg")
      # Set size.
      phantom_svg.width = phantom_svg.height = size.to_i
      # Render PNGs
      #puts "Converting: #{out_dir}/#{moji.code}.png" if @noisy
      phantom_svg.save_apng("#{out_dir}/#{moji.code}.png")
      phantom_svg.reset
      phantom_svg = nil
      moji.paths[:png][size_code] = "#{out_dir}/#{moji.code}.png"
      process_components(moji, size_code, size, out_dir)
      @emoji_in_processing.delete(processing_id)
      @processed_count += 1
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
      print "⚙ Clearing output paths[" if @noisy
      @sizes.each do |key, _val|
        out_dir = "#{@destination}/#{key}"
        print "*" if @noisy
        FileUtils.rm_rf(out_dir)
        FileUtils.mkdir_p(out_dir)
      end
      print "] Done.\n" if @noisy
    end
  end
end
