module Dubious
  module CLI
    class Init < Thor::Group
      include Thor::Actions
      argument :name, :required => true, :desc => "Name of the application/directory"
      source_root File.dirname(__FILE__)+"/../templates/base"
      
      no_tasks do
        def name= name
          @name = name.sub /\/$/,'' #remove trailing slash
        end
      end

      def self.subcommand_help *args
        %Q(
Creates a new dubious project application structure in the NAME directory.
Uses NAME as the appengine app name.
)
      end
      
      def init
        directory '.', "#{name}/"
      end
      
      def cp_dubious_jar
        copy_file '../../../dubious.jar', "#{name}/WEB-INF/lib/dubious.jar"
      end
      
      def cp_mirahdatastore_jar
        copy_file '../../../../javalib/mirahdatastore.jar', "#{name}/WEB-INF/lib/mirahdatastore.jar"
      end
      
    end
  end
end
