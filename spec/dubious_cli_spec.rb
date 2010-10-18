require File.dirname(__FILE__)+'/../lib/dubious/cli'
describe Dubious::CLI do

  describe "subcommands" do
    subject { Dubious::CLI.subcommands }
    it { should include 'new' }
    it { should include 'generate' }
  end
end
