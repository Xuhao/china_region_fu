# coding: utf-8
require 'action_view'
require 'china_region_fu/exceptions'

module ChinaRegionFu
  module Helper

    module FormHelper
      def region_select(object, methods, options = {}, html_options = {})
        output = ''
        options.symbolize_keys!
        html_options.symbolize_keys!

        html_options[:class] ? (html_options[:class].prepend('region_select ')) : (html_options[:class] = 'region_select')
        if Array === methods
          methods.each_with_index do |method, index|
            if klass = method.to_s.classify.safe_constantize
              choices = index == 0 ? klass.select('id, name').collect {|p| [ p.name, p.id ] } : []
              next_method = methods.at(index + 1)
              html_options = set_html_options(object, method, html_options, next_method)

              output << content_tag(:div, select(object, "#{method.to_s}_id", choices, options = options.merge(prompt: options.delete("#{method}_prompt".to_sym)), html_options = html_options), class: "input region #{method.to_s}")
            else
              raise InvalidAttributeError, "Method '#{method}' is not a vaild attribute of #{object}"
            end
          end
          output << javascript_tag(js_output) if methods.size > 1
        else
          if klass = methods.to_s.classify.safe_constantize
            output << content_tag(:div, select(object, methods, klass.select('id, name').collect {|p| [ p.name, p.id ] }, options = options, html_options = html_options), class: "input region #{methods.to_s}")
          else
            raise InvalidAttributeError, "Method '#{method}' is not a vaild attribute of #{object}"
          end
        end
        output.html_safe
      end

      private
        def set_html_options(object, method, html_options, next_region)
          html_options[:data] ? (html_options[:data][:region_klass] = "#{method.to_s}") : (html_options[:data] = { region_klass: "#{method.to_s}" })
          if next_region
            html_options[:data].merge!(region_target: "#{object}_#{next_region.to_s}_id", region_target_kalss: next_region.to_s)
          else
            html_options[:data].delete(:region_target)
            html_options[:data].delete(:region_target_kalss)
          end
          html_options
        end

        def js_output
          <<-JAVASCRIPT
            $(function(){
              $('body').on('change', '.region_select', function(event) {
                var self, targetDom;
                self = $(event.currentTarget);
                targetDom = $('#' + self.data('region-target'));
                if (targetDom.size() > 0) {
                  $.getJSON('/china_region_fu/fetch_options', {klass: self.data('region-target-kalss'), parent_klass: self.data('region-klass'), parent_id: self.val()}, function(data) {
                    var options = [];
                    $('option[value!=""]', targetDom).remove();
                    $.each(data, function(index, value) {
                      options.push("<option value='" + value.id + "'>" + value.name + "</option>");
                    });
                    targetDom.append(options.join(''));
                  });
                }
              });
            });
          JAVASCRIPT
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