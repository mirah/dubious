require File.dirname(__FILE__)+'/../lib/dubious/cli'
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
        Dubious::CLI::Generator.new(['something']).tap{|g|g.destination_root=File.dirname(__FILE__)+'/temp'}.model
      end
    end
  end
end
