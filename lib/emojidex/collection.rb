require 'rapngasm'

module Emojidex
  class Collection
    def convert(options = {})
      _set_options(options)

      @emoji.values.each do |emoji|
        source = "#{@cache_dir}/#{emoji.code}"
        if File.directory?(source)
          _convert_to_apng(source, emoji.code)
        else
          _convert_to_png(emoji.code)
        end
      end
    end

    private

    def _set_options(options)
      @formats = options[:formats] || ':png'

      if options[:sizes].nil?
        @sizes = Emojidex::Defaults.sizes
      else
        @sizes = {}
        sizes = options[:sizes]
        sizes.each do |value|
          @sizes[value] = Emojidex::Defaults.sizes[value]
        end
      end
    end

    def _convert_to_png(filename, source = nil, out = nil)
      @sizes.each do |key, value|
        out_dir = out || "#{@cache_dir}/#{key}"
        FileUtils.mkdir_p(out_dir) unless File.exist?(out_dir)

        source_path = source || "#{@cache_dir}/#{filename}.svg"
        out_path = "#{out_dir}/#{filename}.png"

        converter = Emojidex::Converters::Base.new
        surface = converter.get_surface(source_path, value)
        surface.write_to_png(out_path)
        surface.destroy
      end
    end

    def _convert_to_apng(source_dir, filename)
      @sizes.each do |key, value|
        out_dir = "#{@cache_dir}/#{key}/#{filename}"
        out_path = "#{out_dir}/animation.png"

        @apngasm = APNGAsm.new
        _create_apngframe_from_svg(source_dir, out_dir)
        @apngasm.assemble(out_path)
        @apngasm.reset
      end
    end

    def _create_apngframe_from_svg(source_dir, out_dir)
      Dir.foreach(source_dir) do |f|
        file_path = "#{source_dir}/#{f}"
        if File.ftype(file_path) == 'file' && File.extname(file_path) == '.svg'
          _convert_to_png(File.basename(f, '.svg'), file_path, out_dir)
          @apngasm.add_frame(APNGFrame.new("#{out_dir}/#{File.basename(f, '.svg')}.png"))
        end
      end
    end
  end
end
