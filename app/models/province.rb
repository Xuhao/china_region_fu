# -*- encoding: utf-8 -*-
class Province < ActiveRecord::Base
  attr_accessible :name, :pinyin, :pinyin_abbr
  
	has_many :cities, dependent: :destroy
	has_many :districts, through: :cities
end
