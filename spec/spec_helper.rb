require 'java'
require 'mirah'
require 'appengine-sdk'
require 'rspec'

require AppEngine::SDK::SDK_ROOT + '/lib/shared/geronimo-servlet_2.5_spec-1.2.jar'
require File.dirname(__FILE__)+'/../lib/dubious.jar'
require File.dirname(__FILE__)+'/../javalib/dubydatastore.jar'

import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse

import javax.servlet.Filter
import javax.servlet.FilterChain
import javax.servlet.FilterConfig


Rspec.configure do |config|
  config.mock_with :mocha
end

module Dubious
  include_package 'dubious'
end
