# ChinaRegionFu

[![Gem Version](https://badge.fury.io/rb/china_region_fu.png)](http://badge.fury.io/rb/china_region_fu)
[![Build Status](https://travis-ci.org/Xuhao/china_region_fu.png?branch=master)](https://travis-ci.org/Xuhao/china_region_fu)

ChinaRegionFu provide the region data of china.You will got complete China region data after use this gem.

## Installation

Put 'gem china_region_fu' to your Gemfile:

    gem 'china_region_fu'

Run bundler command to install the gem:

    bundle install

After you install the gem, you need run below tasks one by one:

1. Copy migration file to your app.

    rake china_region_fu_engine:install:migrations

2. Run db:migrate to create region tables.

    rake db:migrate

3. Download the latest regions.yml form [github](https://raw.github.com/Xuhao/china_region_data/master/regions.yml).

    rake region:download

4. Import regions to database.

    rake region:import

You also can use below generator to do the same things:

    rails g china_region_fu:install

Region data is from [ChinaRegionData](https://github.com/Xuhao/china_region_data), check it out to see what kind of data you have now.

If you want to customize the region modules you can run the generator:

    rails g china_region_fu:models

   This will create:

    create  app/models/province.rb
    create  app/models/city.rb
    create  app/models/district.rb

   So you can do what you want to do in this files.

## Usage

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

##### Fetch sub regions by Ajax

Once select one province, we want fetch cities of the selected province and fill the city select box automatically. If you use `:region_select_tag` and FormBuilder/FormHelper method aka `:region_select`, you need do nothing for this. If you use simple_form or normal form helper like `:select_tag` or `:select`, to implement this, what you need to do is add below helper in your form:

```erb
<%= js_for_region_ajax %>
```

it will render:

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

## Online example
[医院之家](http://www.yihub.com/ "医院").

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

ChinaRegionFu is released under the MIT license.

