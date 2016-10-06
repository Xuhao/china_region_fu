module ChinaRegionFu
  module Utilis
    def china_region_fu_js
      js = <<-JAVASCRIPT
        <script type="text/javascript">
          //<![CDATA[
            window.chinaRegionFu = window.chinaRegionFu || {};
            $(function(){
              $('body').off('change', '.china-region-select').on('change', '.china-region-select', function(event) {
                var $self, $targetDom;
                $self = $(event.currentTarget);
                $subRegionDom = $('[data-region-name="' + $self.data('sub-region') + '"]');
                if ($subRegionDom.size() > 0) {
                  $.getJSON('/china_region_fu/fetch_options', {
                      columns: window.chinaRegionFu.fetchColumns || 'id,name',
                      sub_name: $self.data('sub-region'),
                      parent_name: $self.data('region-name'),
                      parent_id: $self.val()
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
                    window.chinaRegionFu.ajaxFail && window.chinaRegionFu.ajaxFail(jqxhr, textStatus, error);
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
