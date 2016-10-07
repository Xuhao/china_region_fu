require 'ostruct'

module ActiveRecord
  class Base < ::OpenStruct; end
end

class Address < ActiveRecord::Base; end

MockModel = Struct.new(:id, :name, :pinyin, :pinyin_abbr, :short_name) do
  def self.pluck(*args)
    []
  end

  def self.where(*args)
    self
  end
end

class Province < MockModel
  def self.pluck(*args)
    [['河南省', 16]]
  end
end

class City < MockModel
  attr_accessor :province_id, :level, :zip_code

  def self.pluck(*args)
    [['信阳市', 166]]
  end
end

class District < MockModel
  attr_accessor :city_id

  def self.pluck(*args)
    [['商城县', 1513]]
  end
end
