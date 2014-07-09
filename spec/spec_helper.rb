require 'emojidex/emoji'
require 'emojidex/collection'
require 'emojidex/converter'

def setup_working_collection
  @support_dir = File.expand_path('../support', __FILE__)

  FileUtils.rmdir("#{@support_dir}/tmp/collection")
  FileUtils.mkdir_p("#{@support_dir}/tmp")
  FileUtils.cp_r("#{@support_dir}/collection", "#{@support_dir}/tmp")
end
