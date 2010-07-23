require 'thor'
require 'thor/group'
module Dubious
  class Init < Thor::Group
    include Thor::Actions
    argument :name
    source_root File.dirname(__FILE__)+"/templates"

    def init
      directory '.', "#{name}/"
    end

    def self.subcommand_help command_name
'foo'
    end
  end

  class CLI < Thor
    desc "init NAME", "initializes a new dubious project in NAME"
    subcommand :init, Init
  end

end
