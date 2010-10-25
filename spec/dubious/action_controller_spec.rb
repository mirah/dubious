require File.dirname(__FILE__)+'/../spec_helper.rb'

describe Dubious::ActionController do
  subject { Dubious::ActionController.new }

  it { should respond_to :do_get }
  
  describe "#do_get" do
    let(:req) { HttpServletRequest.new }
    let(:resp){ HttpServletResponse.new }
    it {
      req.stubs :get_path_info => '/somepath', 
                :get_servlet_path => '/someotherpath',
                :get_parameter => nil
      resp.expects(:set_status).with 404
      resp.stubs :send_redirect => nil
      subject.do_get req, resp
    }
  end

  describe "#action_request" do
    
  end
end
