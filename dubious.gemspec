# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = 'dubious'
  s.version = "0.0.0"
  s.authors = ["Charles Oliver Nutter", "Ryan Brown"]
  s.date = Time.now.strftime("YYYY-MM-DD")
  s.description = %q{}
  s.email = ["headius@headius.com", "ribrdb@google.com"]
  s.executables = ["mirah", "mirahc", "mirahp", "duby", "dubyc", "dubyp"]
  s.extra_rdoc_files = ["History.txt", "README.txt"]
  files = Dir["{bin,lib,test,examples,javalib}/**/*"] + Dir["{*.txt,Rakefile}"]
  s.files = files.reject {|file| file =~ /jruby-complete.jar/}
  s.homepage = %q{http://www.mirah.org/}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{duby}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{}
  s.test_files = Dir["test/**/test*.rb"]
  s.platform = "java"
  s.add_dependency("bitescript", ">= 0.0.6")
end
