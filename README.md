# [English Readme](https://github.com/Xuhao/china_region_fu/blob/master/README.en.md)

# ChinaRegionFu

[![Gem Version](https://badge.fury.io/rb/china_region_fu.png)](http://badge.fury.io/rb/china_region_fu)
[![Build Status](https://travis-ci.org/Xuhao/china_region_fu.png?branch=master)](https://travis-ci.org/Xuhao/china_region_fu)

ChinaRegionFu 是一个提供中国行政区域信息的rails engine(只适用rails)。使用ChinaRegionFu后，你将拥有全面且准确的中国区域数据，而且你还可以使用其提供的表单helper，轻松将具有联动效果的区域选择器放入你的表单中。

![Screenshot](https://cloud.githubusercontent.com/assets/324973/19191241/2c5726a8-8cd4-11e6-960d-6edd1fa69427.gif "Screenshot")

## 运行环境

  * CRuby 2.2 及以上
  * Rails 4.0 及以上
  * jQuery 1.8 及以上, 若不需要联动效果可忽略

## 安装

将 'gem china_region_fu' 放入项目的 Gemfile中:

    gem 'china_region_fu'

运行 bundler 命令来安装:

    bundle install

bundle安装完成后，你需要依次运行以下命令:

  1. 复制数据迁移文件到项目中:

      <pre>rake china_region_fu:install:migrations</pre>

  2. 运行 db:migrate 来创建数据库表:

      <pre>rake db:migrate</pre>

  3. 从[china_region_data](https://raw.github.com/Xuhao/china_region_data)下载最新的<b>[regions.yml](https://raw.github.com/Xuhao/china_region_data/master/regions.yml)</b>:

      <pre>rake china_region_fu:download</pre>

  4. 将区域信息导入到数据库:

      <pre>rake china_region_fu:import</pre>

以上每条命令运行完成后，你可以根据需要对生成的文件做一些修改，然后再运行下一条。如果你不需要做自定义修改，也可以通过下面这条命令实现和上面4个命令同样的动作:

    rake china_region_fu:setup

区域数据来自[china_region_data](https://github.com/Xuhao/china_region_data), 你可以通过查看这个git库来了解都有哪些区域数据。

ChinaRegionFu通过`ActiveRecord`将各种区域映射成类:
 * `Province`: 省、自治区、直辖市、特别行政区
 * `City`: 地区、盟、自治州、地级市
 * `District`: 县、自治县、旗、自治旗、县级市、市辖区、林区、特区

如果你想自定义这些类，可以通过以下命令将其复制到你的项目中:

    rails g china_region_fu:models

   将会创建:

    create  app/models/province.rb
    create  app/models/city.rb
    create  app/models/district.rb

   你可以在以上这些类文件中做任何事。

## 使用说明

### Model

```ruby
a = Province.last
a.name                   # => "台湾省"
a.cities.pluck(:name)    # => ["嘉义市", "台南市", "新竹市", "台中市", "基隆市", "台北市"]

Province.first.districts.pluck(:name) # => ["延庆县", "密云县", "平谷区", ...]

c = City.last
c.name                   # => "酒泉市"
c.short_name             # => "酒泉"
c.zip_code               # => "735000"
c.pinyin                 # => "jiuquan"
c.pinyin_abbr            # => "jq"
c.districts.pluck(:name) # => ["敦煌市", "玉门市", "阿克塞哈萨克族自治县", "肃北蒙古族自治县", "安西县", ...]
c.brothers.pluck(:name)  # => ["甘南藏族自治州", "临夏回族自治州", "陇南市", ...]

d = District.last
d.name                   # => "吉木乃县"
d.short_name             # => "吉木乃"
d.pinyin                 # => "jimunai"
d.pinyin_abbr            # => "jmn"
d.city.name              # => "阿勒泰地区"
d.province.name          # => "新疆维吾尔自治区"
```

### View

#### Form helpers

```erb
<%= form_for(@address) do |f| %>
  <div class="field">
    <%= f.label :province, '选择地区：' %><br />

    # FormBuilder
    <%= f.region_select :city %>
    <%= f.region_select [:province_id, :city_id, :district_id], province_prompt: 'Do', city_prompt: 'it', district_prompt: 'like this' %>
    <%= f.region_select [:province_id, :city_id], include_blank: true %>
    <%= f.region_select [:city_id, :district_id] %>

    # FormHelper
    <%= region_select :address, :province_id %>
    <%= region_select :address, [:province_id, :city_id, :district_id] %>
    ...

    # FormTagHelper
    <%= region_select_tag :province_id, class: 'province-select', include_blank: true %>
    <%= region_select_tag [:province_id, :city_id, :district_id], province_prompt: 'Do', city_prompt: 'it', district_prompt: 'like this', class: 'region-select' %>
    ...
  </div>
<% end %>
```

#### SimpleForm

```erb
<%= simple_form_for(@address) do |f| %>
  <%= f.input :province_id, as: :region, collection: Province.select('id, name'), sub_region: :city_id %>
  <%= f.input :city_id, as: :region, collection: City.where(province_id: f.object.province_id).select('id, name'), sub_region: :district_id %>
  <%= f.input :district_id, as: :region, collection: District.where(city_id: f.object.city_id).select('id, name') %>
  <%= china_region_fu_js %>
<% end %>
```

#### Formtastic

```erb
<%= semantic_form_for(@address) do |f| %>
  <%= f.input :province_id, as: :region, collection: Province.select('id, name'), sub_region: :city_id) %>
  <%= f.input :city_id, as: :region, collection: City.where(province_id: f.object.province_id).select('id, name'), sub_region: :district_id %>
  <%= f.input :district_id, as: :region, collection: District.where(city_id: f.object.city_id).select('id, name') %>
  <%= china_region_fu_js %>
<% end %>
```

#### 通过AJAX实现联动效果

当选中某个省份时，我们希望城市下拉列表自动显示这个省下属的城市；当选择某个城市时，我们希望区域列表显示该城市下属区域。你需要在你的页面中添加以下helper来实现联动效果:

```erb
<%= china_region_fu_js %>
# or
<%= content_for :china_region_fu_js %>
```

将会渲染:

```html
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
            window.chinaRegionFu.ajaxFail && window.chinaRegionFu.ajaxFail(xhr, textStatus, error);
          }).always(function(event, xhr, settings) {
            window.chinaRegionFu.ajaxAlways && window.chinaRegionFu.ajaxAlways(event, xhr, settings);
          });
        }
      });
    });
  //]]>
</script>
```
自定义:

  * `window.chinaRegionFu.fetchColumns`: 设定返回栏位数据，默认: `id,name`
  * `window.chinaRegionFu.ajaxDone(json)`: 自定义ajax `success`事件，默认：重新填充下级选项
  * `window.chinaRegionFu.ajaxFail(xhr, textStatus, error)`: 自定义ajax `fail`事件
  * `window.chinaRegionFu.ajaxAlways(event, xhr, settings)`: 自定义ajax `always`事件

## 在线的例子

[医院之家](http://www.yihub.com/ "医院").

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/xuhao/china_region_fu. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

