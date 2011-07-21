# coding = UTF-8
class District < ActiveRecord::Base
	belongs_to :city
	has_many :hospitals, :dependent => :nullify

	def short_name
		@short_name ||= name.gsub(/区|县|市|自治县/,'')
	end
	
	# 查询同一市的其他地区/县
	def brothers
		@brothers ||= District.where("city_id = #{city_id}")
	end
	
end
