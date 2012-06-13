# -*- encoding: utf-8 -*-
module ChinaRegionFu
  module Helper
    
    module FormHelper
      def region_select(object, methods, options = {}, html_options = {})
        html_options[:class] ? (html_options[:class].prepend('region_select ')) : (html_options[:class] = 'region_select')
        
        output = ''
        if Array === methods
          methods.each_with_index do |method, index|
            if klass = method.to_s.classify.safe_constantize
              choices = index == 0 ? klass.all.collect {|p| [ p.name, p.id ] } : []
              next_method = methods.at(index + 1)
              options[:prompt] = region_prompt(klass)
              html_options[:data] ? (html_options[:data][:region_klass] = "#{method.to_s}") : (html_options[:data] = { region_klass: "#{method.to_s}" })
              if next_method
                html_options[:data].merge!(region_target: "#{object}_#{next_method.to_s}_id", region_target_kalss: next_method.to_s)
              else
                html_options[:data].delete(:region_target)
                html_options[:data].delete(:region_target_kalss)
              end
              
              output << select(object, "#{method.to_s}_id", choices, options = options, html_options = html_options)
            else
              raise "Method '#{method}' is not a vaild attribute of #{object}"
            end
          end
        else
          if klass = methods.to_s.classify.safe_constantize
            options[:prompt] = region_prompt(klass)
            output << select(object, methods, klass.all.collect {|p| [ p.name, p.id ] }, options = options, html_options = html_options)
          else
            raise "Method '#{method}' is not a vaild attribute of #{object}"
          end
        end
        output << javascript_tag(%~
          $(function(){
            $('body').on('change', '.region_select', function(event) {
              var self, target, targetDom;
              self = $(event.currentTarget);
              target = self.data('region-target');
              targetDom = $('#' + target);
              if (targetDom.size() > 0) {
                $.getJSON('/china_region_fu/fetch_options', {klass: self.data('region-target-kalss'), parent_klass: self.data('region-klass'), parent_id: self.val()}, function(data) {
                  $('option[value!=""]', targetDom).remove();
                  $.each(data, function(index, value) {
                    targetDom.append("<option value='" + value.id + "'>" + value.name + "</option>");
                  });
                })
              }
            });
          })
        ~)
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
        @template.region_select(@object_name, methods, options = options, html_options = html_options)
      end
    end
  end
end


ActionView::Base.send :include, ChinaRegionFu::Helper::FormHelper
ActionView::Helpers::FormBuilder.send :include, ChinaRegionFu::Helper::FormBuilder