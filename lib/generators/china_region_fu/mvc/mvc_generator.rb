module ChinaRegionFu
  class MvcGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)

    def manifest  
      record do |m|  
        m.file "layout.rhtml", "app/views/layouts/application.rhtml"  
        m.file "stylesheet.css", "public/stylesheets/application.css"  
      end  
    end

  end
end
