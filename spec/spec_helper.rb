require 'java'
require 'bundler/setup'
require 'rspec/core'
require 'mirah'
require 'appengine-sdk'
require 'mocha'

require AppEngine::SDK::SDK_ROOT + '/lib/shared/servlet-api.jar'
require File.dirname(__FILE__) + '/../lib/dubious.jar'
require File.dirname(__FILE__) + '/../javalib/mirahdatastore.jar'

import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse

import javax.servlet.Filter
import javax.servlet.FilterChain
import javax.servlet.FilterConfig

RSpec.configure do |config|
  config.mock_with :mocha
end

module Dubious
  include_package 'dubious'
end
