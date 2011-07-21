require "yaml"
module ChinaRegionFu
  module ClassMethods
    include Error
    def yaml_records
      raise YmalFileMissingError, "#{YAML_FILE} is missing!" unless File.exist? YAML_FILE
      File.open(YAML_FILE) { |file| YAML.load(file) }
    end

  end
end