module Emojidex
  # Full collection of converters
  module Converters
    require_relative 'converters/base'
    require_relative 'converters/png'
    require_relative 'converters/svg'

    def self.Available
      { svg: Emojidex::Converters::SVG, png: Emojidex::Converters::PNG }
    end
  end
end
