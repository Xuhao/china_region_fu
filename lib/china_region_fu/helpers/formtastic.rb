require 'china_region_fu/helpers/utils'

class RegionInput < Formtastic::Inputs::SelectInput
  include ChinaRegionFu::Utils

  def collection_from_options
    return [] unless options.key?(:collection)
    super
  end

  def input_html_options
    append_html_options(input_name, input_options.delete(:sub_region), super)
  end
end
