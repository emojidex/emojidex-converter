require 'emojidex/collection'

module Emojidex
  # Manages a collection of emoji. + conversion
  class Collection
    def rasterize(override = {})
      converter = Emojidex::Converter.new(override)
      converter.rasterize(@emoji.values, @source_path)
    end

    def preprocess(override = {})
      converter = Emojidex::Converter.new(override)
      converter.preprocess(@emoji.values, @source_path)
    end
  end
end
