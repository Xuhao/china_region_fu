# ChinaRegionFu

[![Gem Version](https://badge.fury.io/rb/china_region_fu.png)](http://badge.fury.io/rb/china_region_fu)
[![Build Status](https://travis-ci.org/Xuhao/china_region_fu.png?branch=master)](https://travis-ci.org/Xuhao/china_region_fu)

ChinaRegionFu 是一个为Rails应用提供的中国行政区域信息的rubygem。使用ChinaRegionFu后，你将拥有全面且准确的中国区域数据，而且你还可以使用其提供的表单helper，轻松将具有联动效果的区域选择器放入你的表单中。

## 安装

将 'gem china_region_fu' 放入项目的 Gemfile中:

    gem 'china_region_fu'

运行 bundler 命令来安装:

    bundle install

bundle安装完成后，你需要依次运行以下命令:

  1. 复制数据迁移文件到项目中:

      <pre>rake china_region_fu_engine:install:migrations</pre>

  2. 运行 db:migrate 来创建数据库表:

      <pre>rake db:migrate</pre>

  3. 从[china_region_data](https://raw.github.com/Xuhao/china_region_data)下载最新的<b>[regions.yml](https://raw.github.com/Xuhao/china_region_data/master/regions.yml)</b>:

      <pre>rake region:download</pre>

  4. 将区域信息导入到数据库:

      <pre>rake region:import</pre>

以上每条命令运行完成后，你可以根据需要对生成的文件做一些修改，然后再运行下一条。如果你不需要做自定义修改，也可以通过下面这条命令实现和上面4个命令同样的动作:

    rake region:install

区域数据来自[ChinaRegionData](https://github.com/Xuhao/china_region_data), 你可以通过查看这个git库来了解都有哪些区域数据。

ChinaRegionFu通过`ActiveRecord`将各种区域映射成类:
 * Province: 省、自治区、直辖市、特别行政区
 * City: 地区、盟、自治州、地级市
 * District: 县、自治县、旗、自治旗、县级市、市辖区、林区、特区

如果你想自定义这些类，可以通过以下命令将其复制到你的项目中:

    rails g china_region_fu:models

   将会创建:

    create  app/models/province.rb
    create  app/models/city.rb
    create  app/models/district.rb

   你可以在以上这些类文件中做任何事。

## 使用说明

#### Model

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

#### View

##### Form helpers

```erb
<%= form_for(@post) do |f| %>
  <div class="field">
    <%= f.label :province, '选择地区：' %><br />

    # FormBuilder
    <%= f.region_select :city %>
    <%= f.region_select [:province, :city, :district], province_prompt: 'Do', city_prompt: 'it', district_prompt: 'like this' %>
    <%= f.region_select [:province, :city], include_blank: true %>
    <%= f.region_select [:city, :district] %>
    <%= f.region_select [:province, :district] %>

    # FormHelper
    <%= region_select :post, :province %>
    <%= region_select :post, [:province, :city, :district] %>
    ...

    # FormTagHelper
    <%= region_select_tag :province, class: 'my', include_blank: true %>
    <%= region_select_tag [:province, :city, :district], province_prompt: 'Do', city_prompt: 'it', district_prompt: 'like this', class: 'my' %>
    ...
  </div>
<% end %>
```

##### SimpleForm

```erb
<%= simple_form_for(@post) do |f| %>
  <%= f.input :province, as: :region, collection: Province.select('id, name'), sub_region: :city %>
  <%= f.input :city, as: :region, sub_region: :district %>
  <%= f.input :district, as: :region %>
  <%= js_for_region_ajax %>
<% end %>
```

##### Formtastic

```erb
<%= semantic_form_for(@post) do |f| %>
  <%= f.input :province, as: :region, collection: Province.select('id, name'), sub_region: :city %>
  <%= f.input :city, as: :region, sub_region: :district %>
  <%= f.input :district, as: :region %>
  <%= js_for_region_ajax %>
<% end %>
```

##### 通过Ajax实现联动效果

当选中某个省份时，我们希望城市下拉列表自动显示这个省下属的城市；当选择某个城市时，我们希望区域列表显示该城市下属区域。如果你使用`:region_select_tag`和`:region_select`这个两个helper构造表单，你不需要左任何额外工作就能获得联动效果。如果你用simple_form, formtastic或使用rails内置的下拉列表helper例如`:select_tag` 和 `:select`, 你需要使用下面这个helper来实现联动效果:

```erb
<%= js_for_region_ajax %>
```

将会渲染:

```html
<script type="text/javascript">
  //<![CDATA[
    $(function(){
      $('body').on('change', '.region_select', function(event) {
        var self, $targetDom;
        self = $(event.currentTarget);
        $targetDom = $('#' + self.data('region-target'));
        if ($targetDom.size() > 0) {
          $.getJSON('/china_region_fu/fetch_options', {klass: self.data('region-target-kalss'), parent_klass: self.data('region-klass'), parent_id: self.val()}, function(data) {
            var options = [];
            $('option[value!=""]', $targetDom).remove();
            $.each(data, function(index, value) {
              options.push("<option value='" + value.id + "'>" + value.name + "</option>");
            });
            $targetDom.append(options.join(''));
          });
        }
      });
    });
  //]]>
</script>
```

## 在线的例子
[医院之家](http://www.yihub.com/ "医院").

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

ChinaRegionFu is released under the MIT license.

