require 'emojidex_converter'
require 'emojidex'


def setup_working_collection
  @support_dir = File.expand_path('../support', __FILE__)

  FileUtils.rmdir("#{@support_dir}/tmp")
  FileUtils.mkdir_p("#{@support_dir}/tmp")
  FileUtils.cp_r("#{@support_dir}/collection", "#{@support_dir}/tmp")

  @collection_out_path = "#{@support_dir}/tmp/collection"
  @collection_out_path
end
