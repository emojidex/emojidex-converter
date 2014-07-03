require 'filemagic'
require 'rsvg2'

module Emojidex
  module Converters
    class Base
      def initialize
      end

      def get_surface(source, size)
        mime = FileMagic.new.file source
        case mime
        when 'SVG Scalable Vector Graphics image'
          return svg_to_surface(source, size)
        end
      end

      def write_surface(surface, destination, formats)
        # surface_to_svg(surface, destination) if formats.key?('svg')
        surface_to_png(surface, destination) if formats.key?('png')
        surface.destroy
      end
    end
  end
end
