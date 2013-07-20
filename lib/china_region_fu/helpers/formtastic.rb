require 'china_region_fu/helpers/utilities'

class RegionInput < Formtastic::Inputs::SelectInput
  include ChinaRegionFu::Utilities

  def collection_from_options
    return [] unless options.key?(:collection)
    super
  end

  def input_html_options
    the_options = append_region_class(super.dup)
    the_options = set_html_options(object_name, input_name, the_options, input_options.delete(:sub_region).to_s.sub(/_id\Z/, '').foreign_key) if input_options.key?(:sub_region)
    the_options
  end
end