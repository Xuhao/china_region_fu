require 'china_region_fu/exceptions'
require 'china_region_fu/helpers/utilities'

module ChinaRegionFu
  module Helpers
    include Utilities

    def region_select_tag(names, options = {})
      append_region_class(options)

      if Array === names
        output = ActiveSupport::SafeBuffer.new
        names.each_with_index do |name, index|
          if klass = to_class(name)
            choices = index == 0 ? options_from_collection_for_select(klass.select('id, name'), "id", "name") : ''
            next_name = names.at(index + 1)
            set_html_options(nil, name, options, next_name)

            output << content_tag(:div, select_tag(name, choices, options.merge(prompt: options.delete("#{name}_prompt".to_sym))), class: "input region #{name.to_s}")
          else
            raise InvalidAttributeError
          end
        end
        output << js_for_region_ajax if names.size > 1
        output
      else
        if klass = to_class(names)
          select_tag(names, options_from_collection_for_select(klass.select('id, name'), "id", "name"), options)
        else
          raise InvalidAttributeError
        end
      end
    end

    def region_select(object, methods, options = {}, html_options = {})
      options.symbolize_keys!
      html_options.symbolize_keys!
      append_region_class(html_options)

      if Array === methods
        output = ActiveSupport::SafeBuffer.new
        methods.each_with_index do |method, index|
          if klass = method.to_s.classify.safe_constantize
            choices = index == 0 ? klass.select('id, name').collect {|p| [ p.name, p.id ] } : []
            next_method = methods.at(index + 1)
            set_html_options(object, method, html_options, next_method)

            output << content_tag(:div, select(object, method.to_s, choices, options.merge(prompt: options.delete("#{method}_prompt".to_sym)), html_options = html_options), class: "input region #{method.to_s}")
          else
            raise InvalidAttributeError
          end
        end
        output << js_for_region_ajax if methods.size > 1
        output
      else
        if klass = methods.to_s.classify.safe_constantize
          content_tag(:div, select(object, methods, klass.select('id, name').collect {|p| [ p.name, p.id ] }, options = options, html_options = html_options), class: "input region #{methods.to_s}")
        else
          raise InvalidAttributeError
        end
      end
    end
  end

  module FormBuilder
    def region_select(methods, options = {}, html_options = {})
      @template.region_select(@object_name, methods, options = options, html_options = html_options)
    end
  end
end