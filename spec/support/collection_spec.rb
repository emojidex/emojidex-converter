require 'spec_helper'

require 'emojidex/collection'

describe Emojidex::Collection do
  let(:collection) do
    Emojidex::Collection.new
  end

  describe '.new' do
    it 'is an instance of Emojidex::Collection' do
      expect(collection).to be_an_instance_of(Emojidex::Collection)
    end
  end

  describe 'Class Monkey Patches' do
    it 'has the original class methods' do
      expect(collection.methods).to include(:load_local_collection)
    end

    it 'has new methods added to the original class' do
      expect(collection.methods).to include(:rasterize)
    end
  end


  describe '.rasterize' do
    it 'converts collection SVGs to PNG' do
      setup_working_collection
      collection.preprocess
      collection.rasterize

      expect(File.exist?("#{@support_dir}/tmp/collection/ldpi/kiss.png")).to be_truthy
      expect(File.exist?("#{@support_dir}/tmp/collection/mdpi/kiss.png")).to be_truthy
      expect(File.exist?("#{@support_dir}/tmp/collection/hdpi/kiss.png")).to be_truthy
      expect(File.exist?("#{@support_dir}/tmp/collection/xhdpi/kiss.png")).to be_truthy
      expect(File.exist?("#{@support_dir}/tmp/collection/px8/kiss.png")).to be_truthy
      expect(File.exist?("#{@support_dir}/tmp/collection/px16/kiss.png")).to be_truthy
      expect(File.exist?("#{@support_dir}/tmp/collection/px32/kiss.png")).to be_truthy
      expect(File.exist?("#{@support_dir}/tmp/collection/px64/kiss.png")).to be_truthy
      expect(File.exist?("#{@support_dir}/tmp/collection/px128/kiss.png")).to be_truthy
      expect(File.exist?("#{@support_dir}/tmp/collection/px256/kiss.png")).to be_truthy
    end
  end
end
