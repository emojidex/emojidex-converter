module Emojidex
  # emoji base class, with conversion functionality
  class Emoji
    attr_reader :code

    def initialize(override = {})
      @code = override[:code].nil? ? '' : override[:code]
    end

    def convert(format, size)
    end
  end
end
