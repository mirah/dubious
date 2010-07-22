begin
  require 'ant'
rescue
  puts 'This Rakefile requires JRuby. Please use jruby -S rake.'
  exit 1
end

if  ENV['MIRAH_HOME'] && File.exist?(ENV['MIRAH_HOME'] +'/lib/mirah.rb')
  $: << File.expand_path(ENV['MIRAH_HOME'] +'/lib')
end

if File.exist?('../bitescript/lib/bitescript.rb')
   $: << File.expand_path('../bitescript/lib/')
end

require 'mirah/appengine_tasks'
require 'rake/clean'

CLEAN.include('build')
CLOBBER.include("WEB-INF/lib/*.jar", 'WEB-INF/appengine-generated')

def class_files_for files
  files.map do |f|
    explode = f.split('/')[1..-1]
    explode.last.gsub!(/(^[a-z]|_[a-z])/) {|m|m.sub('_','').upcase}
    explode.last.sub! /\.(duby|java|mirah)$/, '.class'
    'build/' + explode.join('/')
  end
end

APP_SRC = Dir["app/**/{*.duby,*.mirah}"]
APP_CLASSES = class_files_for APP_SRC
APP_MODEL_CLASSES = APP_CLASSES.select {|app| app.include? '/models' }
APP_CONTROLLER_CLASSES = APP_CLASSES.select {|app| app.include? '/controllers' }
TEMPLATES = Dir["app/views/**/*.erb"]

MODEL_JAR = "WEB-INF/lib/dubydatastore.jar"
LIB_MIRAH_SRC = Dir["lib/**/*.duby"]
LIB_JAVA_SRC  = Dir["lib/**/*.java"]
LIB_SRC = LIB_MIRAH_SRC + LIB_JAVA_SRC
LIB_CLASSES = class_files_for LIB_SRC

STDLIB_CLASSES= LIB_CLASSES.select{|l|l.include? 'stdlib'}

CLASSPATH = [AppEngine::Rake::SERVLET, AppEngine::SDK::API_JAR].join(":")

appengine_app :app, 'app', '' => ["WEB-INF/lib/application.jar",
                                  "WEB-INF/lib/dubious.jar",
                                  ]
Duby.dest_paths << 'build'
Duby.source_paths << 'lib'
Duby.compiler_options << '--classpath' << [File.expand_path('build'),"WEB-INF/lib"].join(':')

directory 'build'

file "build/dubious/Inflection.class" => :'compile:java'
file "build/dubious/ScopedParameterMap.class" => :'compile:java'
file "build/dubious/ActionController.class" => ["build/dubious/Params.class", "build/dubious/FormHelper.class", "build/dubious/AssetTimestampsCache.class"]
file "build/dubious/Inflections.class" => "build/dubious/Inflection.class"
file "build/dubious/FormHelper.class" => ["build/dubious/Inflections.class", *STDLIB_CLASSES]
file "build/dubious/Params.class" => "build/dubious/ScopedParameterMap.class"

APP_CONTROLLER_CLASSES.each do |f|
  file f => APP_MODEL_CLASSES + TEMPLATES
end

APP_CLASSES.each do |f|
  file f => LIB_CLASSES
end

namespace :compile do
  task :app => [:dubious, "WEB-INF/lib/application.jar"]
  task :dubious => "WEB-INF/lib/dubious.jar"
  task :java => 'build' do
    ant.javac :srcdir=>'lib', :destdir=>'build', :classpath=>CLASSPATH
  end
end

desc "compile app"
task :compile => 'compile:app'

file "WEB-INF/lib/dubious.jar" => [MODEL_JAR] + LIB_CLASSES do
  includes = LIB_CLASSES.map {|d|d.sub 'build/',''}.join(',')
  ant.jar :destfile=>"WEB-INF/lib/dubious.jar", :basedir=>'build',
          :includes=>includes
end

file "WEB-INF/lib/application.jar" => APP_CLASSES do
  includes = APP_CLASSES.map {|d|d.sub 'build/',''}.join(',')
  ant.jar :destfile=>"WEB-INF/lib/application.jar", :basedir=>'build',
          :includes=>includes
end

task :default => :server

MIRAH_HOME = ENV['MIRAH_HOME'] ? ENV['MIRAH_HOME'] : Gem.find_files('mirah').first.sub(/lib\/mirah.rb/,'')
 
MODEL_SRC_JAR =  File.join(MIRAH_HOME, 'examples', 'appengine', 'war',
                                 'WEB-INF', 'lib', 'dubydatastore.jar')

file MODEL_JAR => MODEL_SRC_JAR do |t|
  cp MODEL_SRC_JAR, MODEL_JAR
end

task :generate_build_properties do
  def git_data(dir, file='')
    returning = nil
    chdir dir do
      # ["commit abc....123", "2010-06-23 12:58:06 -0700"]
      IO.popen("git rev-list --pretty=format:%ci -1 HEAD #{file}") do |f|
        returning = [f.gets.chomp, f.gets.chomp]
      end
    end
    returning
  end

  dubious_data = git_data(".")
  mirah_data = git_data(MIRAH_HOME)
  bite_data = git_data(MIRAH_HOME + '/../bitescript')
  model_data = git_data(File.dirname(MODEL_SRC_JAR),File.basename(MODEL_SRC_JAR))

  prop_file = "config/build.properties"
  File.open(prop_file, 'w') do |f| 
    f.write <<-EOF
# the current build environment
application.build.time=#{Time.now.xmlschema}
dubious.version.commit=#{dubious_data[0][7..-1]}
dubious.version.time=#{Time.parse(dubious_data[1]).xmlschema}
mirah.version.commit=#{mirah_data[0][7..-1]}
mirah.version.time=#{Time.parse(mirah_data[1]).xmlschema}
bitescript.version.commit=#{bite_data[0][7..-1]}
bitescript.version.time=#{Time.parse(bite_data[1]).xmlschema}
model.version.commit=#{model_data[0][7..-1]}
model.version.time=#{Time.parse(model_data[1]).xmlschema}
    EOF
  end

end
