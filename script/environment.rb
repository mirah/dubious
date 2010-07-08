#!/usr/bin/ruby
require 'fileutils'
require 'time'

# fetch some information from git to stash at build time
# populate the WEB-INF/lib dir

MODEL_JAR = 'dubydatastore.jar'

def git_data(dir, file='')
  
  FileUtils.cd dir
  # ["commit abc....123", "2010-06-23 12:58:06 -0700"]
  IO.popen("git rev-list --pretty=format:%ci -1 HEAD #{file}") do |f|
    [f.gets.chomp, f.gets.chomp]
  end
end

def mirah_cmd
  IO.popen("which duby") { |f| f.gets.chop }
end

def sdk_jars(web_inf_lib_dir)
  glob = "appengine-api-{1.0-sdk,labs}-*.jar"
  srcjars = Dir.glob("#{ENV['APPENGINE_JAVA_SDK']}/lib/user/#{glob}")
  targets = Dir.glob("#{web_inf_lib_dir}/#{glob}")
  compare = (srcjars + targets).map { |p| p.split('/')[-1] }
  return if compare.uniq.size == 2 and compare.size == 4
  targets.each {|t| FileUtils.rm(t)}  # ditch old versions
  srcjars.each {|f| FileUtils.cp(f, web_inf_lib_dir)}
end

base = File.join(File.dirname(__FILE__), '..')
model_jar = File.expand_path(File.join(base, 'WEB-INF', 'lib', MODEL_JAR))
web_lib  = File.expand_path(File.join(base, 'WEB-INF', 'lib'))
conf_dir = File.expand_path(File.join(base, 'config'))
sdk_jars(web_lib)
prop_file = File.join(conf_dir, 'build.properties')
mirah_dir = ENV['MIRAH_HOME'] # use the environment when possible
mirah_dir = File.join(File.dirname(mirah_cmd), '..') if mirah_dir.nil?
mirah_data = git_data(mirah_dir)
bite_dir = File.join(mirah_dir, '..', 'bitescript')
bite_data = git_data(bite_dir)
model_dir = File.join(mirah_dir, 'examples', 'appengine', 'war',
                                 'WEB-INF', 'lib')
model_src = File.join(model_dir, MODEL_JAR)
model_data = git_data(model_dir, MODEL_JAR)
FileUtils.cp(model_src, model_jar) unless File.exists?(model_jar) and
   File.size(model_src) == File.size(model_jar)

properties = <<EOF
# the current build environment
application.build.time=#{Time.now.xmlschema}
mirah.version.commit=#{mirah_data[0][7..-1]}
mirah.version.time=#{Time.parse(mirah_data[1]).xmlschema}
bitescript.version.commit=#{bite_data[0][7..-1]}
bitescript.version.time=#{Time.parse(bite_data[1]).xmlschema}
model.version.commit=#{model_data[0][7..-1]}
model.version.time=#{Time.parse(model_data[1]).xmlschema}
EOF
File.open(prop_file, 'w') {|f| f.write(properties) }
