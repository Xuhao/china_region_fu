class City < ActiveRecord::Base
  belongs_to :province
  has_many :districts, dependent: :destroy

  def short_name
    @short_name ||= name.gsub(/市|(回族|哈萨克|柯尔克孜|彝族|蒙古(族)?|白族|朝鲜族|傣族|景颇族|傈僳族|土家族|壮族|苗族|藏族|哈尼族|羌族|侗族|布依)?自治州|地区|特别行政区$/,'')
  end
end
