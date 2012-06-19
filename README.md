# ChinaRegionFu

ChinaRegionFu provide the region data of china.You will got complete chian region data after use this gem.
       

## Installation

Put 'gem china_region_fu' to your Gemfile:

    gem 'china_region_fu'

Run bundler command to install the gem:

    bundle install

After you install the gem, you need run the generator:

    rails g china_region_fu:install
   
   It will:
   * Generate `db/migrate/<timestamp>create_china_region_tables.rb` migrate file to your app, `provinces`, `cities`, `districts` table is used for store the regions.
   * Copy regions.yml to config/ directory.
   * Run `rake db:migrate`.
   * Run `rake region:import`.

   Now you have there ActiveRecord modules: `Province`, `City`, `District`.
   
   Run with `rails g` for get generator list.

If you want to customize the region modules you can run the generator:

    rails g china_region_fu:mvc

   This will create:
   
    create  app/models/province.rb
    create  app/models/city.rb
    create  app/models/district.rb

   So you can do what you want to do in this files.
   
## Usage

#### Model

    a = Province.last
    a.name                # => "台湾省"
    a.cities.map(&:name)  # => ["嘉义市", "台南市", "新竹市", "台中市", "基隆市", "台北市"]
    
    Province.first.districts.map(&:name) # => ["延庆县", "密云县", "平谷区", ...]
    
    c = City.last
    c.name                # => "酒泉市"
    c.zip_code            # => "735000"
    c.pinyin              # => "jiuquan"
    c.pinyin_abbr         # => "jq"
    c.districts.map(&:name) # => ["敦煌市", "玉门市", "阿克塞哈萨克族自治县", "肃北蒙古族自治县", "安西县", ...]
    c.brothers.map(&:name)  # => ["甘南藏族自治州", "临夏回族自治州", "陇南市", ...]
    
#### View

    <%= form_for(@post) do |f| %>
      <div class="field">
        <%= f.label :province, '选择地区：' %><br />
        
        # FormBuilder
        # <%= f.region_select :city %>
        # <%= f.region_select [:province, :city, :district] %>
        # <%= f.region_select [:province, :city] %>
        # <%= f.region_select [:city, :district] %>
        # <%= f.region_select [:province, :district] %>
        
        # FormHelper
        # <%= region_select :post, :province %>
        # <%= region_select :post, [:province, :city, :district] %>
        # ...
        
      </div>
    <% end %>

##### prompt
  
You need define `province_select_prompt`, `city_select_prompt`, `district_select_prompt` helpers for each select prompt.
If you have not define these helpers, it will use the default one like:
    
    def region_prompt(region_klass)
      human_name = region_klass.model_name.human
      "请选择#{human_name}"
    end
    
  Online example: [医院之家](http://www.yihub.com/ "医院").

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

ChinaRegionFu is released under the MIT license.

