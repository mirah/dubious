require 'thor'
require 'thor/group'
require 'active_support/core_ext'
require 'active_support'

require File.dirname(__FILE__) + '/cli/init'
require File.dirname(__FILE__) + '/cli/generator'

module Dubious

  module CLI
    
    class Main < Thor
      desc "new NAME", "creates a new dubious project in NAME"
      subcommand :new, Init
      
      desc "generate GENERATOR", "run generator GENERATOR"
      subcommand :generate, Generator
    end
    
    def self.start
      Main.start
    end
  end
end
