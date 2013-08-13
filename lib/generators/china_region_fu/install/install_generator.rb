module ChinaRegionFu
  class InstallGenerator < Rails::Generators::Base

    def copy_migration_file
      rake 'china_region_fu_engine:install:migrations'
    end

    def execute_migrate
      rake 'db:migrate'
    end

    def download_region_config_file
      rake 'region:download'
    end


    def import_region_to_db
      rake 'region:import'
    end
  end
end
