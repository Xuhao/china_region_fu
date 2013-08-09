module ChinaRegionFu
  class InstallGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    source_root File.expand_path('../templates', __FILE__)

    def copy_migration_file
      migration_template "migration.rb", "db/migrate/create_china_region_tables.rb"
    end

    def execute_migrate
      rake("db:migrate")
    end

    desc "Download https://github.com/Xuhao/china_region_data/raw/master/regions.yml to config/regions.yml."
    def download_region_config_file
      get 'https://github.com/Xuhao/china_region_data/raw/master/regions.yml', 'config/regions.yml'
    rescue
      puts "\e[31mWarnning!!!\e[0m"
      puts "Download \e[33mregions.yml\e[0m failed!"
      puts ''
      puts 'You need do:'
      puts "1. download: \e[33mhttps://github.com/Xuhao/china_region_data/raw/master/regions.yml\e[0m"
      puts '2. put it to config/ direcotry.'
      puts "3. run: \e[32mrake region:import\e[0m"
      abort
    end


    def import_region_to_data
      rake('region:import')
    end

    def self.next_migration_number(dirname)
      if ActiveRecord::Base.timestamped_migrations
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      else
        "%.3d" % (current_migration_number(dirname) + 1)
      end
    end
  end
end
