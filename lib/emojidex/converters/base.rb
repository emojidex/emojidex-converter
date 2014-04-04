module Emojidex::Converters
  class Base
    def initialize
    end

    private

    def get_surface(source, pxsize)
      mime = FileMagic.new.file source
      case mime
      when 'SVG Scalable Vector Graphics image'
        return svg_to_surface(source, size)
      end
    end

    def svg_to_surface(source, size)
      handle = RSVG::Handle.new_from_file(file)

      dim = handle.dimensions
      ratio_w = size.to_f / dim.width.to_f
      ratio_h = size.to_f / dim.height.to_f

      surface = Cairo::ImageSurface.new(:argb32, target_size, target_size)
      context = Cairo::Context.new(surface)
      context.scale(ratio_w, ratio_h)
      context.render_rsvg_handle(handle)
      context.destroy

      surface
    end

    def png_to_surface(source, size)
    end
  end
end
