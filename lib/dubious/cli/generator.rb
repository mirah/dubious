module Dubious
  module CLI
    class Generator < Thor
      include Thor::Actions
      source_root File.dirname(__FILE__)+"/../templates/generator"
      argument :name
      
      
      desc "model NAME", "creates model file" 
      def model#(name)
        template "model.mirah.tt", "app/models/#{name.underscore}.mirah"
      end
      
      desc "controller NAME", "creates controller file"
      def controller#(name)
        template "controller.mirah.tt", "app/controllers/#{name.underscore}_controller.mirah"
        empty_directory "app/views/#{name.underscore}"
        inject_into_file "WEB-INF/app.yaml", "  - url: /#{name.underscore}/*\n    servlet: controllers.#{name.classify}Controller\n    name: #{name.underscore}\n",:after => "handlers:\n"
      end
      
    end
  end
end
