require 'phantom_svg'

module Emojidex::Converters
  # compile svg files in a svg animation file
  class Preprocessor
    def compile_svg_animations(path)
      Dir.entries(path).each do |file|
        if File.ftype("#{path}/#{file}") == 'directory'
          compile("#{path}/#{file}") if file != '.' && file != '..'
        end
      end
    end

    private

    def compile(source_dir)
      filename = set_filename(source_dir)

      Dir.entries(source_dir).each do |file|
        if file == 'animation.json'
          svg = Phantom::SVG::Base.new
          svg.add_frame_from_file("#{source_dir}/#{file}")
          svg.save_svg("#{filename}.svg")
        end
      end

      FileUtils.move("#{filename}.svg", File.dirname(source_dir))
    end

    def set_filename(source_dir)
      start_index = source_dir.rindex('/')
      source_dir[start_index + 1..source_dir.length - 1]
    end
  end
end
