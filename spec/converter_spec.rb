require 'spec_helper'

describe Emojidex::Converter do
  let(:converter) do
    @destination = File.expand_path('../support/tmp/out', __FILE__)
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
      expect(converter.sizes.size).to eq(Emojidex::Defaults.sizes.size)
    end

    it 'overrides sizes when passed in initialization' do
      conv = Emojidex::Converter.new(sizes: { px200: 200, px1024: 1024, way_too_big: 20_000_000 })
      expect(conv.sizes).to eq(px200: 200, px1024: 1024, way_too_big: 20_000_000)
    end
  end

  describe '.preprocess' do
    it 'preprocesses folders with SVG frame and animation.json files into frame-animated SVGs' do
      setup_working_collection
      converter.preprocess("#{@collection_out_path}")
      expect(File.exist?("#{@collection_out_path}/heartbeat.svg")).to be true
    end
  end

  describe '.rasterize' do
    it 'converts base SVG from the source directory to PNG in the destination directory' do
      setup_working_collection
      converter.preprocess("#{@collection_out_path}")
      converter.rasterize([Emojidex::Data::Emoji.new(code: 'kiss')],
                          "#{@collection_out_path}")

      expect(File.exist?("#{@destination}/ldpi/kiss.png")).to be true
      expect(File.exist?("#{@destination}/mdpi/kiss.png")).to be true
      expect(File.exist?("#{@destination}/hdpi/kiss.png")).to be true
      expect(File.exist?("#{@destination}/xhdpi/kiss.png")).to be true
      expect(File.exist?("#{@destination}/px8/kiss.png")).to be true
      expect(File.exist?("#{@destination}/px16/kiss.png")).to be true
      expect(File.exist?("#{@destination}/px32/kiss.png")).to be true
      expect(File.exist?("#{@destination}/px64/kiss.png")).to be true
      expect(File.exist?("#{@destination}/px128/kiss.png")).to be true
      expect(File.exist?("#{@destination}/px256/kiss.png")).to be true
    end
  end

  describe '.rasterize_collection' do
    it 'converts an emojidex collection' do
      setup_working_collection
      converter.preprocess(@collection_out_path)
      collection = Emojidex::Data::Collection.new(local_load_path: @collection_out_path)
      processed_collection = converter.rasterize_collection(collection)

      expect(File.exist?("#{@destination}/ldpi/kiss.png")).to be_truthy
      expect(File.exist?("#{@destination}/emoji.json")).to be_truthy

      processed_collection.generate_checksums
      expect(processed_collection.emoji.values.first.checksums[:png][:ldpi]).to be_truthy
    end
  end
end
