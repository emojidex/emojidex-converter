module Emojidex
  # Manages a collection of emoji. + conversion
  class Collection
    def convert(options = {})
      converter = Emojidex::Converter.new(options)

      @emoji.values.each do |emoji|
        converter.convert(emoji, @cache_dir)
      end
    end
  end
end
