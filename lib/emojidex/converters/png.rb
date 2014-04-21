require 'rapngasm'

module Emojidex::Converters
  class PNG < Emojidex::Converters::Base
    def png_to_surface(source, size)
    end

    def surface_to_svg(surface, destination)
    end

    def convert_to_apng(filename, sizes, source_dir)
      [*sizes].each do |key, value|
        size = {}
        size[key] = value
        out_dir = "#{source_dir}/#{key}/#{filename}"
        FileUtils.mkdir_p(out_dir) unless File.exist?(out_dir)

        @apngasm = APNGAsm.new
        add_apngframe(size, "#{source_dir}/#{filename}", out_dir)
        @apngasm.assemble("#{out_dir}/animation.png")
        @apngasm.reset
      end
    end

    def add_apngframe(size, source_dir, out_dir)
      Dir.foreach(source_dir) do |f|
        file_path = "#{source_dir}/#{f}"
        if File.ftype(file_path) == 'file' && File.extname(file_path) == '.svg'
          svg = Emojidex::Converters::SVG.new
          svg.convert_to_png(File.basename(f, '.svg'), size, source_dir, out_dir)
          @apngasm.add_frame(APNGFrame.new("#{out_dir}/#{File.basename(f, '.svg')}.png"))
        elsif File.ftype(file_path) == 'file' && File.extname(file_path) == '.png'
          @apngasm.add_frame(APNGFrame.new(f))
        end
      end
    end
  end
end
