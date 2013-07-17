require "rails"
require 'china_region_fu/helpers'

module ChinaRegionFu
  class Engine < Rails::Engine
    initializer "form helper extensions" do
      ActiveSupport.on_load :action_view do
        ActionView::Base.send :include, ChinaRegionFu::Helpers::FormHelper
        ActionView::Base.send :include, ChinaRegionFu::Helpers::FormTagHelper
        ActionView::Helpers::FormBuilder.send :include, ChinaRegionFu::Helpers::FormBuilder
      end
    end
  end
end