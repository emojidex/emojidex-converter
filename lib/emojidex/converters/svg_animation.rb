require 'phantom_svg'

module Emojidex::Converters
  class SVGAnimation < Emojidex::Converters::Base
    def initialize
    end

    def convert_to_animation(path)
      root_dir = delete_slash(path)

      Dir::entries(root_dir).each do |file|
        if File::ftype("#{root_dir}/#{file}") == "directory"
          if file != '.' && file != '..'
            convert("#{root_dir}/#{file}") 
          end
        end
      end
    end

    private

    def convert(source_dir)
      filename = set_filename(source_dir)
      
      Dir::entries(source_dir).each do |file|
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

    def delete_slash(str)
      if str.rindex('/') == str.length - 1
        str = str[0, str.length - 1]
      end

      str
    end
  end
end
