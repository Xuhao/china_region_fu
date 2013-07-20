# coding: utf-8
class City < ActiveRecord::Base
  if Rails.version < '4.0'
    attr_accessible :name, :province_id, :level, :zip_code, :pinyin, :pinyin_abbr
  end

  belongs_to :province
  has_many :districts, dependent: :destroy

  def short_name
    @short_name ||= name.gsub(/市|自治州|地区|特别行政区/,'')
  end

  def brothers
    @brothers ||= City.where("province_id = #{province_id}")
  end

end
