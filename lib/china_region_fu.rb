module ChinaRegionFu
  YAML_FILE = File.expand_path('../../config/regions.yml', __FILE__)

  def self.included(base)
    base.extend ClassMethods
  end

end


require "china_region_fu/version"
require "china_region_fu/error"
require "china_region_fu/class_methods"
