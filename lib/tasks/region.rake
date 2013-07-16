require 'yaml'

namespace :region do

  desc "Import region data to database from config/regions.yml"
  task :import => :environment do
    file_path = File.join(Rails.root, 'config', 'regions.yml')
    regions = File.open(file_path) { |file| YAML.load(file) }
    cleanup_regins
    load_to_db(regions)
    puts "Regions import done!"
  end

  def cleanup_regins
    Province.delete_all
    City.delete_all
    District.delete_all
  end

  def load_to_db(regions)
    regions.each do |province_name, province_hash|
      current_province = Province.where(name: province_name, pinyin: province_hash['pinyin'], pinyin_abbr: province_hash['pinyin_abbr']).first_or_create!
      cities_hash = province_hash['cities']
      cities_hash.each do |city_name, city_hash|
        current_city = current_province.cities.where(name: city_name, pinyin: city_hash['pinyin'], pinyin_abbr: city_hash['pinyin_abbr'], zip_code: city_hash['zip_code'], level: city_hash['level'] || 4).first_or_create!
        districts_hash = city_hash['districts']
        districts_hash.each do |district_name, district_hash|
          current_city.districts.where(name: district_name, pinyin: district_hash['pinyin'], pinyin_abbr: district_hash['pinyin_abbr']).first_or_create!
        end
      end
    end
  end

end