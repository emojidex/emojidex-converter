module Emojidex::Converters
  # SVG handling for emojidex converters
  class SVG < Emojidex::Converters::Base
    def svg_to_surface(source, size)
      handle = RSVG::Handle.new_from_file(source)

      dim = handle.dimensions
      ratio_w = size.to_f / dim.width.to_f
      ratio_h = size.to_f / dim.height.to_f

      surface = Cairo::ImageSurface.new(:argb32, size, size)
      context = Cairo::Context.new(surface)
      context.scale(ratio_w, ratio_h)
      context.render_rsvg_handle(handle)
      context.destroy

      surface
    end

    def surface_to_png(surface, out_path)
      surface.write_to_png(out_path)
      surface.destroy
    end

    def convert_to_png(filename, sizes, source_dir, out = nil)
      [*sizes].each do |key, value|
        out_dir = out || "#{source_dir}/#{key}"
        FileUtils.mkdir_p(out_dir) unless File.exist?(out_dir)

        surface = get_surface("#{source_dir}/#{filename}.svg", value)
        surface_to_png(surface, "#{out_dir}/#{filename}.png")
      end
    end
  end
end
