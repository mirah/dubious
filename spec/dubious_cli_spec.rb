require 'spec_helper'
require 'dubious/cli'

describe Dubious::CLI do

  before :each do
    FileUtils.rm_rf 'spec/temp'
    Dir.mkdir 'spec/temp'
  end

  describe "subcommands" do
    subject { Dubious::CLI::Main.subcommands }
    it { should include 'new' }
    it { should include 'generate' }
  end

  describe Dubious::CLI::Generator do
    it 'expects a name' do
      lambda {
        Dubious::CLI::Generator.new
      }.should raise_error
    end

    describe "#model" do
      it '...' do
        generator = Dubious::CLI::Generator.new(['something'], :quiet=>true)
        generator.destination_root=File.dirname(__FILE__)+'/temp'
        generator.model
      end
    end
  end
end
