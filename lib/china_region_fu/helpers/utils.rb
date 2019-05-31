require 'active_support/core_ext/object/deep_dup'
require 'active_support/core_ext/string/output_safety'

module ChinaRegionFu
  module Utils
    def china_region_fu_js
      js = <<-JAVASCRIPT
        <script type="text/javascript">
          //<![CDATA[
            window.chinaRegionFu = window.chinaRegionFu || {};
            $(function(){
              $('body').off('change', '.china-region-select').on('change', '.china-region-select', function(event) {
                var $self = $(event.currentTarget),
                  $subRegionDom = $('[data-region-name="' + $self.data('sub-region') + '"]'),
                  subName = $self.data('sub-region'),
                  parentName = $self.data('region-name'),
                  parentId = $self.val();
                if ($subRegionDom.length > 0 && subName && parentName && parentId) {
                  $.getJSON('/china_region_fu/fetch_options', {
                      columns: window.chinaRegionFu.fetchColumns || 'id,name',
                      sub_name: subName,
                      parent_name: parentName,
                      parent_id: parentId
                    }, function(json) {
                      if (window.chinaRegionFu.ajaxDone) {
                        window.chinaRegionFu.ajaxDone(json);
                      } else {
                        var options = [];
                        $self.parent().nextAll().find('.china-region-select > option[value!=""]').remove()
                        $.each(json.data, function(_, value) {
                          options.push("<option value='" + value.id + "'>" + value.name + "</option>");
                        });
                        $subRegionDom.append(options.join(''));
                      }
                  }).fail(function(xhr, textStatus, error) {
                    window.chinaRegionFu.ajaxFail && window.chinaRegionFu.ajaxFail(xhr, textStatus, error);
                  }).always(function(event, xhr, settings) {
                    window.chinaRegionFu.ajaxAlways && window.chinaRegionFu.ajaxAlways(event, xhr, settings);
                  });
                }
              });
            });
          //]]>
        </script>
      JAVASCRIPT
      js.html_safe
    end

    def append_html_class_option(html_options)
      _html_options = html_options.deep_dup
      _html_options[:class] ||= ''
      _html_options[:class] << ' china-region-select' unless _html_options[:class].include?('china-region-select')
      _html_options
    end

    def append_html_data_option(current_region, sub_region, html_options)
      _html_options = html_options.deep_dup
      _html_options[:data] ||= {}
      _html_options[:data][:region_name] = current_region
      if sub_region
        _html_options[:data][:sub_region] = sub_region
      else
        _html_options[:data].delete(:sub_region)
      end
      _html_options
    end

    def append_html_options(current_region, sub_region, html_options)
      _html_options = html_options.deep_dup
      _html_options = append_html_class_option(_html_options)
      _html_options = append_html_data_option(current_region, sub_region, _html_options)
      _html_options
    end

    def append_prompt(current_region, options)
      current_name = current_region.to_s.sub(/_id\Z/, '')
      options_without_prompt = options.except(:province_prompt, :city_prompt, :district_prompt)
      options_without_prompt[:prompt] = options["#{current_name}_prompt".to_sym]
      options_without_prompt
    end
  end
end
