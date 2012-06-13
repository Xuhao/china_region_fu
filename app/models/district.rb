# -*- encoding: utf-8 -*-
class District < ActiveRecord::Base
  attr_accessible :name, :city_id, :pinyin, :pinyin_abbr
  
	belongs_to :city
	belongs_to :province

	def short_name
		@short_name ||= name.gsub(/区|县|市|自治县/,'')
	end
	
	def brothers
		@brothers ||= District.where("city_id = #{city_id}")
	end
	
end
