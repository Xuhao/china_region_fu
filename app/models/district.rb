class District < ActiveRecord::Base
  belongs_to :city
  has_one :province, through: :city

  def short_name
    @short_name ||= name.sub(/区|县|市|自治县$/,'')
  end
end
