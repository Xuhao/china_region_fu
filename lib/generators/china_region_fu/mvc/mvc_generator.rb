module ChinaRegionFu
  class MvcGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('../../../../../app', __FILE__)

    def copy_model_file
      copy_file "models/province.rb", "app/models/province.rb"
      copy_file "models/city.rb", "app/models/city.rb"
      copy_file "models/district.rb", "app/models/district.rb"
    end

    def copy_controller_file
      copy_file "controllers/region_controller.rb", "app/controllers/region_controller.rb"
    end

    def copy_view_file
      empty_directory 'app/views/region'
      template_type = (file_name =~ /^erb$|^haml$/ ? file_name : 'erb')
      copy_file "views/region/index.html.#{template_type}", "app/views/region/index.html.#{template_type}"
    end
  end
end
