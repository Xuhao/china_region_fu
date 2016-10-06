class City < ActiveRecord::Base
  belongs_to :province
  has_many :districts, dependent: :destroy

  def short_name
    @short_name ||= name.sub(/市|自治州|地区|特别行政区$/,'')
  end
end
