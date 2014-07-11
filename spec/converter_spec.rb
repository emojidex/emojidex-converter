require 'spec_helper'

describe Emojidex::Converter do
  let(:converter) do
    @destination = './tmp/out'
    FileUtils.remove_entry_secure(@destination, true)
    Emojidex::Converter.new(destination: @destination)
  end

  describe '.new' do
    it 'successfully creates a new Converter object' do
      expect(converter).to be_an_instance_of(Emojidex::Converter)
    end
  end

  describe '.sizes' do
    it 'is a hash of size codes and sizes in px' do
      expect(converter.sizes).to be_an_instance_of(Hash)
      expect(converter.sizes.size).to eq(Emojidex::Converter.default_sizes.size)
    end

    it 'overrides sizes when passed in initialization' do
      conv = Emojidex::Converter.new(sizes: { px200: 200, px1024: 1024, way_too_big: 20_000_000 })
      expect(conv.sizes).to eq(px200: 200, px1024: 1024, way_too_big: 20_000_000)
    end
  end

  describe '.preprocess' do
    it 'preprocesses folders with SVG frame and animation.json files into frame-animated SVGs' do
      setup_working_collection
      converter.preprocess("#{@support_dir}/tmp/collection")
      expect(File.exist?("#{@support_dir}/tmp/collection/heartbeat.svg")).to be true
    end
  end

  describe '.convert' do
    it 'converts base SVG from the source directory to PNG in the destination directory' do
      setup_working_collection
      converter.preprocess("#{@support_dir}/tmp/collection")
      converter.convert([Emojidex::Emoji.new(code: 'kiss')], "#{@support_dir}/tmp/collection")

      expect(File.exist?("#{@destination}/ldpi/kiss.png")).to be_truthy
      expect(File.exist?("#{@destination}/mdpi/kiss.png")).to be_truthy
      expect(File.exist?("#{@destination}/hdpi/kiss.png")).to be_truthy
      expect(File.exist?("#{@destination}/xhdpi/kiss.png")).to be_truthy
      expect(File.exist?("#{@destination}/px8/kiss.png")).to be_truthy
      expect(File.exist?("#{@destination}/px16/kiss.png")).to be_truthy
      expect(File.exist?("#{@destination}/px32/kiss.png")).to be_truthy
      expect(File.exist?("#{@destination}/px64/kiss.png")).to be_truthy
      expect(File.exist?("#{@destination}/px128/kiss.png")).to be_truthy
      expect(File.exist?("#{@destination}/px256/kiss.png")).to be_truthy
    end
  end
end
