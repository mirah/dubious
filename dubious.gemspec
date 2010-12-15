# -*- encoding: utf-8 -*-
require 'lib/dubious/version'

Gem::Specification.new do |s|
  s.name = 'dubious'
  s.summary = %q{A web framework for Mirah, running on appengine.}
  s.authors = ["John Woodell",      "Nick Howard"]
  s.email   = ["woodie@netpress.com", "ndh@baroquebobcat.com"]
  s.version = Dubious::VERSION
  s.license = "Apache-2.0"
  s.date = Time.now.strftime("YYYY-MM-DD")
  s.description = %q{Dubious is a web framework written in Mirah.}
  s.executables = ["dubious"]
  s.files = Dir["{bin,lib,test,examples,javalib}/**/*"] + Dir["{*.txt,Rakefile}"]
  s.homepage = %q{http://github.com/mirah/dubious/}
  s.extra_rdoc_files = ["LICENSE", "ROADMAP.rdoc", "README.rdoc"]
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.platform = "java"
  s.add_dependency("thor","0.13.8")
  s.add_dependency("activesupport")
  s.add_dependency("i18n")
  s.add_dependency("mirah", ">= 0.0.4") 
  s.add_dependency("appengine-sdk", "~> 1.3")
end
