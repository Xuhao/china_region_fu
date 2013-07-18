# ChinaRegionFu

[![Gem Version](https://badge.fury.io/rb/china_region_fu.png)](http://badge.fury.io/rb/china_region_fu)
[![Build Status](https://travis-ci.org/Xuhao/china_region_fu.png?branch=master)](https://travis-ci.org/Xuhao/china_region_fu)

ChinaRegionFu provide the region data of china.You will got complete chian region data after use this gem.

## Installation

Put 'gem china_region_fu' to your Gemfile:

    gem 'china_region_fu'

Run bundler command to install the gem:

    bundle install

After you install the gem, you need run the generator:

    rails g china_region_fu:install

   It will:
   * Generate `db/migrate/<timestamp>create_china_region_tables.rb` migrate file to your app.
   * Download [https://github.com/Xuhao/china_region_data/raw/master/regions.yml](https://github.com/Xuhao/china_region_data/raw/master/regions.yml) to config/regions.yml.
   * Run `rake db:migrate`.
   * Run `rake region:import`.

   Now you have there ActiveRecord modules: `Province`, `City`, `District`.

Region data if from [ChinaRegionData](https://github.com/Xuhao/china_region_data), check it out to see what kind of data you have now.

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
a.name                # => "台湾省"
a.cities.map(&:name)  # => ["嘉义市", "台南市", "新竹市", "台中市", "基隆市", "台北市"]

Province.first.districts.map(&:name) # => ["延庆县", "密云县", "平谷区", ...]

c = City.last
c.name                  # => "酒泉市"
c.zip_code              # => "735000"
c.pinyin                # => "jiuquan"
c.pinyin_abbr           # => "jq"
c.districts.map(&:name) # => ["敦煌市", "玉门市", "阿克塞哈萨克族自治县", "肃北蒙古族自治县", "安西县", ...]
c.brothers.map(&:name)  # => ["甘南藏族自治州", "临夏回族自治州", "陇南市", ...]
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
<%= f.input :province, as: :region, collection: Province.select('id, name'), sub_region: :city %>
<%= f.input :city, as: :region, sub_region: :district %>
<%= f.input :district, as: :region %>
<%= js_for_region_ajax %>
```

##### Fetch sub regions by Ajax

Once select one province, we want fill the city select box by cities of the selected province. Implement this, what you need to do is

add below helper in your page:

```erb
<%= js_for_region_ajax %>
```

  Online example: [医院之家](http://www.yihub.com/ "医院").

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

ChinaRegionFu is released under the MIT license.

