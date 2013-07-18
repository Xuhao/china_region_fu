require 'china_region_fu/helpers/utilities'

class RegionInput < SimpleForm::Inputs::CollectionInput
  include ChinaRegionFu::Utilities

  def input
    label_method, value_method = detect_collection_methods
    append_region_class(input_html_options)
    set_html_options(object_name, attribute_name, input_html_options, input_options.delete(:sub_region)) if input_options.key?(:sub_region)
    region_collection = collection
    region_collection = [] if region_collection == SimpleForm::Inputs::CollectionInput.boolean_collection
    @builder.collection_select(
      attribute_name, region_collection, value_method, label_method,
      input_options, input_html_options
    )
  end
end