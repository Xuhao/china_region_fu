# coding: utf-8
class District < ActiveRecord::Base
  if Rails.version < '4.0'
    attr_accessible :name, :city_id, :pinyin, :pinyin_abbr
  end

  belongs_to :city
  has_one :province, through: :city

  def short_name
    @short_name ||= name.gsub(/区|县|市|自治县/,'')
  end

  def brothers
    @brothers ||= District.where("city_id = #{city_id}")
  end

end
