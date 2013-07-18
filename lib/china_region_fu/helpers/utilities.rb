module ChinaRegionFu
  module Utilities
    def js_for_region_ajax
      js = <<-JAVASCRIPT
        <script type="text/javascript">
          //<![CDATA[
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
          //]]>
        </script>
      JAVASCRIPT
      js.html_safe
    end

    def set_html_options(object, method, html_options, next_region)
      region_klass_name = method.to_s.sub(/_id\Z/, '')
      next_region_klass_name = next_region.to_s.sub(/_id\Z/, '')
      html_options[:data] ? (html_options[:data][:region_klass] = "#{region_klass_name}") : (html_options[:data] = { region_klass: "#{region_klass_name}" })
      if next_region
        region_target = object ? "#{object}_#{next_region.to_s}" : next_region.to_s
        html_options[:data].merge!(region_target: region_target, region_target_kalss: next_region_klass_name)
      else
        html_options[:data].delete(:region_target)
        html_options[:data].delete(:region_target_kalss)
      end
      html_options
    end

    def to_class(str_name)
      return nil if str_name.blank?
      str_name.to_s.classify.safe_constantize
    end

    def append_region_class(options)
      options[:class] ? (options[:class].prepend('region_select ')) : (options[:class] = 'region_select')
    end
  end
end