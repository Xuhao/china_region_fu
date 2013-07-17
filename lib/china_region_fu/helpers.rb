# coding: utf-8
require 'china_region_fu/exceptions'

module ChinaRegionFu
  module Helpers

    module FormTagHelper
      def region_select_tag(names, options = {})
        options[:class] ? (options[:class].prepend('region_select ')) : (options[:class] = 'region_select')
        if Array === names
          output = ActiveSupport::SafeBuffer.new
          names.each_with_index do |name, index|
            if klass = name.to_s.classify.safe_constantize
              choices = index == 0 ? options_from_collection_for_select(klass.select('id, name'), "id", "name") : ''
              next_name = names.at(index + 1)
              options = set_html_options(nil, name, options, next_name)

              output << content_tag(:div, select_tag(name, choices, options.merge(prompt: options.delete("#{name}_prompt".to_sym))), class: "input region #{name.to_s}")
            else
              raise InvalidAttributeError
            end
          end
          output << javascript_tag(js_output) if names.size > 1
          output
        else
          if klass = names.to_s.classify.safe_constantize
            select_tag(names, options_from_collection_for_select(klass.select('id, name'), "id", "name"), options)
          else
            raise InvalidAttributeError
          end
        end
      end
    end

    module FormHelper
      def region_select(object, methods, options = {}, html_options = {})
        options.symbolize_keys!
        html_options.symbolize_keys!

        html_options[:class] ? (html_options[:class].prepend('region_select ')) : (html_options[:class] = 'region_select')
        if Array === methods
          output = ActiveSupport::SafeBuffer.new
          methods.each_with_index do |method, index|
            if klass = method.to_s.classify.safe_constantize
              choices = index == 0 ? klass.select('id, name').collect {|p| [ p.name, p.id ] } : []
              next_method = methods.at(index + 1)
              html_options = set_html_options(object, method, html_options, next_method)

              output << content_tag(:div, select(object, "#{method.to_s}_id", choices, options.merge(prompt: options.delete("#{method}_prompt".to_sym)), html_options = html_options), class: "input region #{method.to_s}")
            else
              raise InvalidAttributeError
            end
          end
          output << javascript_tag(js_output) if methods.size > 1
          output
        else
          if klass = methods.to_s.classify.safe_constantize
            content_tag(:div, select(object, methods, klass.select('id, name').collect {|p| [ p.name, p.id ] }, options = options, html_options = html_options), class: "input region #{methods.to_s}")
          else
            raise InvalidAttributeError
          end
        end
      end

      private
        def set_html_options(object, method, html_options, next_region)
          html_options[:data] ? (html_options[:data][:region_klass] = "#{method.to_s}") : (html_options[:data] = { region_klass: "#{method.to_s}" })
          if next_region
            region_target = object ? "#{object}_#{next_region.to_s}_id" : next_region.to_s
            html_options[:data].merge!(region_target: region_target, region_target_kalss: next_region.to_s)
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