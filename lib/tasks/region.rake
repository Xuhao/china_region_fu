require 'httparty'

namespace :region do

  desc 'Install china region fu'
  task :install do
    Rake::Task['china_region_fu_engine:install:migrations'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['region:download'].invoke
    Rake::Task['region:import'].invoke
  end

  desc 'Download regions.yml from https://raw.github.com/Xuhao/china_region_data/master/regions.yml'
  task :download do
    begin
      remote_url = 'https://raw.github.com/Xuhao/china_region_data/master/regions.yml'
      puts 'Downloading ...'
      File.open(Rails.root.join('config', 'regions.yml'), 'wb') { |f| f.write(HTTParty.get(remote_url).body)}
      puts "Done! File located at: \e[32mconfig/regions.yml\e[0m"
    rescue
      puts "\e[31mWarnning!!!\e[0m"
      puts "Download \e[33mregions.yml\e[0m failed!"
      puts ''
      puts "You need download \e[33mregions.yml\e[0m by hand from:"
      puts "\e[32mhttps://github.com/Xuhao/china_region_data/raw/master/regions.yml\e[0m"
    end
  end

  desc "Import region data to database from config/regions.yml"
  task :import => :environment do
    puts 'Importing ...'
    file_path = Rails.root.join('config', 'regions.yml')
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