# -*- encoding: utf-8 -*-
module ChinaRegionFu
  module Helper
    
    module FormHelper
      def region_select(object, methods, options = {}, html_options = {})
        output = ''
        if Array === methods
          methods.each_with_index do |method, index|
            if klass = method.to_s.classify.safe_constantize
              choices = index == 0 ? klass.all.collect {|p| [ p.name, p.id ] } : []
              output << select(object, method, choices, options = { prompt: region_prompt(klass) }, html_options = {})
            else
              raise "Method '#{method}' is not a vaild attribute of #{object}"
            end
          end
        else
          if klass = methods.to_s.classify.safe_constantize
            output << select(object, methods, klass.all.collect {|p| [ p.name, p.id ] }, options = { prompt: region_prompt(klass) }, html_options = {})
          else
            raise "Method '#{method}' is not a vaild attribute of #{object}"
          end
        end
        output.html_safe
      end
    
    
      private
        
      def region_prompt(klass)
        human_name = klass.model_name.human
        "请选择#{human_name}"
      end
  
    end
    
    
    module FormBuilder
      def region_select(methods, options = {}, html_options = {})
        @template.region_select(@object_name, methods, options = {}, html_options = {})
      end
    end
  end
end


ActionView::Base.send :include, ChinaRegionFu::Helper::FormHelper
ActionView::Helpers::FormBuilder.send :include, ChinaRegionFu::Helper::FormBuilder