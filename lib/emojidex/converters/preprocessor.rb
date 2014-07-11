require 'phantom_svg'

module Emojidex
  module Converters
    # compile svg files in a svg animation file
    class Preprocessor
      def compile_svg_animations(path)
        Dir.entries(path).each do |file|
          current_path = "#{path}/#{file}"
          next unless File.ftype(current_path) == 'directory'
          compile(current_path) unless file.start_with?('.')
        end
      end

      private

      def compile(source_dir)
        json_path = "#{source_dir}/animation.json"

        return unless File.exist?(json_path)

        phantom_svg = Phantom::SVG::Base.new(json_path)
        phantom_svg.save_svg("#{File.dirname(source_dir)}/#{File.basename(source_dir)}.svg")
      end
    end
  end
end
