# [中文说明](https://github.com/Xuhao/china_region_fu/blob/master/README.zh-cn.md)

# ChinaRegionFu

[![Build Status](https://travis-ci.org/Xuhao/china_region_fu.svg?branch=master)](https://travis-ci.org/Xuhao/china_region_fu)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/85643743367e47d6853b94431f4f503f)](https://www.codacy.com/app/xuhao/china_region_fu?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=Xuhao/china_region_fu&amp;utm_campaign=Badge_Grade)
[![Codacy Badge](https://api.codacy.com/project/badge/Coverage/85643743367e47d6853b94431f4f503f)](https://www.codacy.com/app/xuhao/china_region_fu?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=Xuhao/china_region_fu&amp;utm_campaign=Badge_Coverage)
[![Gem Version](https://badge.fury.io/rb/china_region_fu.svg)](https://badge.fury.io/rb/china_region_fu)

ChinaRegionFu is a rails engine(means only suit for rails) that provide region data of china and handy view helpers. You will got complete China region data after use this gem.

![Screenshot](https://cloud.githubusercontent.com/assets/324973/19191241/2c5726a8-8cd4-11e6-960d-6edd1fa69427.gif "Screenshot")

## Requirements

  * CRuby 2.2 or greater
  * Rails 4.0 or greater
  * jQuery 1.8 or greater, ignore if don't need reactive effect

## Installation

Put 'gem china_region_fu' to your Gemfile:

    gem 'china_region_fu'

Run bundler command to install the gem:

    bundle install

After you install the gem, you need run below tasks one by one:

  1. Copy migration file to your app.

      <pre>rake china_region_fu:install:migrations</pre>

  2. Run db:migrate to create region tables.

      <pre>rake db:migrate</pre>

  3. Download the latest regions.yml form [github](https://raw.github.com/Xuhao/china_region_data/master/regions.yml).

      <pre>rake china_region_fu:download</pre>

  4. Import regions to database.

      <pre>rake china_region_fu:import</pre>

You also can use below task to do the same things as four tasks above:

    rake region:install

Region data is from [ChinaRegionData](https://github.com/Xuhao/china_region_data), check it out to see what kind of data you have now.

If you want to customize the region modules you can run the generator:

    rails g china_region_fu:models

   This will create:

    create  app/models/province.rb
    create  app/models/city.rb
    create  app/models/district.rb

   So you can do what you want to do in this files.

## Usage

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

#### Reactive effect by Ajax

Once select one province, we want fetch cities of the selected province and fill the city select box automatically. to implement this, you need add below helper in your form:

```erb
<%= china_region_fu_js %>
# or
<%= content_for :china_region_fu_js %>
```

it will render:

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
hooks:

  * `window.chinaRegionFu.fetchColumns`: Set columns of each returned region, default: `id,name`
  * `window.chinaRegionFu.ajaxDone(json)`: Customize ajax `success` event，default: reload sub region options
  * `window.chinaRegionFu.ajaxFail(xhr, textStatus, error)`: Customize ajax `fail` event
  * `window.chinaRegionFu.ajaxAlways(event, xhr, settings)`: Customize ajax `always` event

## Online example

[yihub.com](http://www.yihub.com/ "医院").

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/xuhao/china_region_fu. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

