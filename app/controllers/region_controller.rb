class RegionController < ApplicationController
  
  def index
    @provinces, @province_groups = Province.select('id, name, pinyin').all, []
		('A'..'Z').each do |letter|
			@province_groups << [letter, @provinces.find_all{ |province| province.pinyin[0].upcase == letter }]
		end
  end
  
end