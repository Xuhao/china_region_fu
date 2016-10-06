class Province < ActiveRecord::Base
  has_many :cities, dependent: :destroy
  has_many :districts, through: :cities
end
