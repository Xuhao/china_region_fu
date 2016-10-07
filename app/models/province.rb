class Province < ActiveRecord::Base
  has_many :cities, dependent: :destroy
  has_many :districts, through: :cities

  def short_name
    @short_name ||= name.sub(/省|市|(回族|壮族|维吾尔)?自治区|特别行政区&/, '')
  end
end
