require 'china_region_fu/helpers/helpers'

module ChinaRegionFu
  class Engine < ::Rails::Engine
    isolate_namespace ChinaRegionFu

    initializer 'china_region_fu: form helper extensions' do
      ActiveSupport.on_load :action_view do
        ActionView::Base.send :include, ChinaRegionFu::Helpers::FormHelper
        ActionView::Helpers::FormBuilder.send :include, ChinaRegionFu::Helpers::FormBuilder
      end
    end

    initializer 'china_region_fu: third-party extensions' do
      require 'china_region_fu/helpers/simple_form' if Object.const_defined?('SimpleForm')
      require 'china_region_fu/helpers/formtastic' if Object.const_defined?('Formtastic')
    end
  end
end
