# -*- encoding: utf-8 -*-
$: << './lib'
require 'dubious/version'

Gem::Specification.new do |s|
  s.name = 'dubious'
  s.summary = %q{A web framework for Mirah, running on Google App Engine.}
  s.authors = ["John Woodell", "Nick Howard"]
  s.email   = ["woodie@netpress.com", "ndh@baroquebobcat.com"]
  s.version = Dubious::VERSION
  s.license = "Apache-2.0"
  s.date = Time.now.strftime("%Y-%m-%d")
  s.description = %q{Dubious is a web framework written in Mirah.}
  s.executables = ["dubious"]
  s.files = Dir["{bin,lib,test,examples,javalib}/**/*","{*.txt,Rakefile}"] + [
    'lib/dubious.jar',
    'javalib/mirahdatastore.jar'
  ]
  s.homepage = %q{http://github.com/mirah/dubious/}
  s.extra_rdoc_files = ["LICENSE", "ROADMAP.rdoc", "README.rdoc"]
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.platform = "java"

  s.add_dependency("thor", "0.13.8")
  s.add_dependency("activesupport")
  s.add_dependency("i18n")
  s.add_dependency("mirah", "0.0.5")
  s.add_dependency("mirah_model", "0.0.2")
  s.add_dependency("appengine-sdk", "~> 1.4.0")

  s.add_development_dependency("rspec")
  s.add_development_dependency("mocha")
end
