require 'emojidex/emoji'
require 'emojidex/collection'
require 'emojidex/converter'

@support_dir = File.expand_path('../support', __FILE__) 

def setup_working_collection
  FileUtils.rmdir("#{@support_dir}/tmp/collection")
  FileUtils.copy("#{@support_dir}/collection", "#{@support_dir}/tmp/collection")
end
