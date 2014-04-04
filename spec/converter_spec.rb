require 'spec_helper'
require 'emojidex/converter'

describe Emojidex::Converter do
  let(:converter) do
    Emojidex::Converter.new
  end

  describe 'converter' do
    it 'successfully creates a converter object' do
      expect(converter).to be_an_instance_of(Emojidex::Converter)
    end
  end

  describe '.sizes' do
    it 'is a hash of size codes and sizes in px' do
      expect(converter.sizes).to be_an_instance_of(Hash)
      expect(converter.sizes.size).to be >= 10
    end
  end
end
