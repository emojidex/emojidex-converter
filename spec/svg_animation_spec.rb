require 'spec_helper'
require 'emojidex/converter'

describe Emojidex::Converters::SVGAnimation do
  describe 'convert_to_animation' do
    before do
      @anim_converter = Emojidex::Converters::SVGAnimation.new
      @forder_path = "#{File.dirname(__FILE__)}/support"
    end

    it 'successfully creates a svg animation file' do
      @anim_converter.convert_to_animation(@forder_path)
      expect(File.exist?("#{@forder_path}/dancer.svg")).to be true
    end
  end
end
