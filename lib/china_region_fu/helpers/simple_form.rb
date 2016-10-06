require 'china_region_fu/helpers/utilis'

module ChinaRegionFu
  module SimpleForm
    class RegionInput < ::SimpleForm::Inputs::CollectionSelectInput
      include ChinaRegionFu::Utilis
      def input_html_options
        append_html_options(attribute_name, sub_region, super)
      end

      def collection
        @collection ||= options.delete(:collection) || []
      end

      private

        def sub_region
          @sub_region ||= input_options.delete(:sub_region)
        end
    end
  end
end

::SimpleForm::FormBuilder.map_type :region, to: ChinaRegionFu::SimpleForm::RegionInput
