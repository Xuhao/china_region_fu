require 'china_region_fu/errors'
require 'china_region_fu/helpers/utils'
require 'active_support/core_ext/object/blank'

module ChinaRegionFu
  module Helpers
    module FormHelper
      include Utils

      def region_select_tag(regions, options = {})
        render_region_select_tags(nil, regions, ActiveSupport::SafeBuffer.new, options)
      end

      def region_select(object, methods, options = {}, html_options = {})
        render_region_select_tags(object, methods, ActiveSupport::SafeBuffer.new, options, html_options)
      end

      private

        def render_region_select_tags(object, regions, buffer = ActiveSupport::SafeBuffer.new, options = {}, html_options = {})
          regions = (regions.is_a?(Symbol) || regions.is_a?(String)) ? [regions] : regions.to_a
          regions.each_with_index do |region, index|
            if klass = region.to_s.sub(/_id\Z/, '').classify.safe_constantize
              buffer << content_tag(:div, make_select(object, klass, region, regions.at(index + 1), index, options, html_options), class: "input region #{region}")
            else
              raise ChinaRegionFu::InvalidFieldError, "Invalid region field: `#{region}`, valid fields are: province, province_id, city, city_id, district and district_id."
            end
          end
          content_for(:china_region_fu_js) { china_region_fu_js }
          buffer
        end

        def make_select(object, klass, region, sub_region, order_index, options = {}, html_options = {})
          choices = order_index == 0 ? klass.pluck(:name, :id) : get_choices(object, klass, region, options[:object])
          if object
            select(object, region, choices, append_prompt(region, options), append_html_options(region, sub_region, html_options))
          else
            select_tag(region, options_for_select(choices), append_html_options(region, sub_region, append_prompt(region, options)))
          end
        end

        def get_choices(object, klass, region, ar_object)
          return [] if object.blank?
          return [] if !ar_object.is_a?(ActiveRecord::Base)
          if %w(city city_id).include?(region.to_s) && ar_object.province_id.present?
            klass.where(province_id: ar_object.province_id).pluck(:name, :id)
          elsif %w(district district_id).include?(region.to_s) && ar_object.city_id.present?
            klass.where(city_id: ar_object.city_id).pluck(:name, :id)
          else
            []
          end
        end
    end

    module FormBuilder
      def region_select(methods, options = {}, html_options = {})
        @template.region_select(@object_name, methods, objectify_options(options), @default_options.merge(html_options))
      end
    end
  end
end
