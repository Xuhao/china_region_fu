class District < ActiveRecord::Base
	belongs_to :city
	has_many :hospitals, :dependent => :nullify

	# 查询同一市的其他地区/县
	def brothers
		District.where("city_id = #{city_id}")
	end

	# 得分前10名的医院
	def top(size)
		hospitals.order("grade").limit(size)
	end

	def short_name
		@short_name ||= name.gsub(/区|县|市|自治县/,'')
	end
end
