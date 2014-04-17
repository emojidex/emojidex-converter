require 'rapngasm'

module Emojidex
  class Collection
    # def convert(options)
    def convert(size)
      # @formats = 
      # @sizes = 
      @emoji.values.each do |emoji|
        source = "#{@cache_dir}/#{emoji.code}"
        if File.directory?(source)
          _convert_to_apng(source, emoji, size)
        else
          _convert_to_png(emoji, size)
        end
      end
    end

    private

    def _convert_to_png(emoji, size, source = nil, out = nil)
      out_dir = out || "#{@cache_dir}/px#{size}"
      FileUtils.mkdir_p(out_dir) unless File.exist?(out_dir)
      source_path = source || "#{@cache_dir}/#{emoji.code}.svg"
      out_path = if out.nil? || source.nil?
                   "#{out_dir}/#{emoji.code}.png"
                 else
                   "#{out_dir}/#{File.basename(source, '.svg')}.png"
                 end

      converter = Emojidex::Converters::Base.new
      surface = converter.get_surface(source_path, size)
      surface.write_to_png(out_path)
      surface.destroy
    end

    def _convert_to_apng(source_dir, emoji, size)
      out_dir = "#{@cache_dir}/px#{size}/#{emoji.code}"
      apngasm = APNGAsm.new

      Dir.foreach(source_dir) do |f|
        file_path = "#{source_dir}/#{f}"
        if File.ftype(file_path) == 'file' && File.extname(file_path) == '.svg'
          _convert_to_png(emoji, size, file_path, out_dir)
          apngasm.add_frame(APNGFrame.new("#{out_dir}/#{File.basename(f, '.svg')}.png"))
        end
      end

      out_path = "#{out_dir}/animation.png"
      apngasm.assemble(out_path)
    end
  end
end