require "rails"
require 'china_region_fu/helpers/helpers'

module ChinaRegionFu
  class Engine < Rails::Engine
    initializer "form helper extensions" do
      ActiveSupport.on_load :action_view do
        ActionView::Base.send :include, ChinaRegionFu::Helpers
        ActionView::Helpers::FormBuilder.send :include, ChinaRegionFu::FormBuilder
      end
    end

    initializer "simple extension" do
      require "china_region_fu/helpers/simple_form" if Object.const_defined?("SimpleForm")
    end
  end
end