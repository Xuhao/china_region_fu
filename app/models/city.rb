class City < ActiveRecord::Base
	belongs_to :province
	has_many :districts, :dependent => :destroy
	has_many :hospitals, :dependent => :nullify

	# 城市的简短名，去除了‘市’，‘地区’这些字。
	# 杭州市 => 杭州； 信阳地区 => 信阳
	def short_name
		@short_name ||= name.gsub(/市|自治州|地区|特别行政区/,'')
	end

	# 查询同一省的其他城市
	def brothers
		City.where("province_id = #{province_id}")
	end

	# 得分前10名的医院
	def top(size)
		hospitals.order("grade").limit(size)
	end
	
end
