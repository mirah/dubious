begin
  require 'ant'
rescue LoadError
  puts 'This Rakefile requires JRuby. Please use jruby -S rake.'
  exit 1
end


neighbor_mirah = File.expand_path '../mirah'

if File.exists?(neighbor_mirah)
  ENV['MIRAH_HOME'] ||= neighbor_mirah
end

if  ENV['MIRAH_HOME'] && File.exist?(ENV['MIRAH_HOME'] +'/lib/mirah.rb')
  $: << File.expand_path(ENV['MIRAH_HOME'] +'/lib')
end

require 'rake/clean'
require 'mirah/appengine_tasks'


if File.exist?('../bitescript/lib/bitescript.rb')
   $: << File.expand_path('../bitescript/lib/')
end

MIRAH_HOME = ENV['MIRAH_HOME'] ? ENV['MIRAH_HOME'] : Gem.find_files('mirah').first.sub(/lib\/mirah.rb/,'')
 
MODEL_SRC_JAR =  File.join(MIRAH_HOME, 'examples', 'appengine', 'war',
                                 'WEB-INF', 'lib', 'dubydatastore.jar')


def mirahc *files
  if files[-1].kind_of?(Hash)
    options = files.pop
  else
    options = {}
  end
  source_dir = options.fetch(:dir, Duby.source_path)
  dest = File.expand_path(options.fetch(:dest, Duby.dest_path))
  files = files.map {|f| f.sub(/^#{source_dir}\//, '')}
  flags = options.fetch(:options, Duby.compiler_options)
  args = ['-d', dest, *flags] + files
  chdir(source_dir) do
    cmd = "mirahc #{args.join ' '}"
    puts cmd
    if files.any? {|f|f.include? 'controllers'}
      system cmd
    else
      Duby.compile(*args)
      Duby.reset
    end
  end
end

OUTDIR = 'WEB-INF/classes'

def class_files_for files
  files.map do |f|
    explode = f.split('/')[1..-1]
    explode.last.gsub!(/(^[a-z]|_[a-z])/) {|m|m.sub('_','').upcase}
    explode.last.sub! /\.(duby|java|mirah)$/, '.class'
    OUTDIR + '/' + explode.join('/')
  end
end

MODEL_JAR = "WEB-INF/lib/dubydatastore.jar"

LIB_MIRAH_SRC = Dir["lib/**/*.{duby,mirah}"]
LIB_JAVA_SRC  = Dir["lib/**/*.java"]
LIB_SRC = LIB_MIRAH_SRC + LIB_JAVA_SRC
LIB_CLASSES = class_files_for LIB_SRC

STDLIB_CLASSES= LIB_CLASSES.select{|l|l.include? 'stdlib'}

CLASSPATH = [AppEngine::Rake::SERVLET, AppEngine::SDK::API_JAR].join(":")

Duby.dest_paths << OUTDIR
Duby.source_paths << 'lib'
Duby.source_paths << 'app'
Duby.compiler_options << '--classpath' << [File.expand_path(OUTDIR), *FileList["WEB-INF/lib/*.jar"].map{|f|File.expand_path(f)}].join(':') + ':' + CLASSPATH

CLEAN.include(OUTDIR)
CLOBBER.include("WEB-INF/lib/dubious.jar", 'WEB-INF/appengine-generated')

APP_SRC = Dir["app/**/{*.duby,*.mirah}"]
APP_CLASSES = class_files_for APP_SRC
APP_MODEL_CLASSES = APP_CLASSES.select {|app| app.include? '/models' }
APP_CONTROLLER_CLASSES = APP_CLASSES.select {|app| app.include? '/controllers' }
APP_APPLICATION_CONTROLLER_CLASS = APP_CONTROLLER_CLASSES.find {|controller| controller.include? 'ApplicationController' }
TEMPLATES = Dir["app/views/**/*.erb"]

directory OUTDIR

(APP_CLASSES+LIB_CLASSES).zip(APP_SRC+LIB_SRC).each do |klass,src|
  file klass => src
end

APP_CONTROLLER_CLASSES.reject {|k|k == APP_APPLICATION_CONTROLLER_CLASS}.each do |klass|
  file klass => APP_APPLICATION_CONTROLLER_CLASS
end

APP_CONTROLLER_CLASSES.each do |f|
  file f => APP_MODEL_CLASSES + TEMPLATES
end

APP_CLASSES.each do |f|
  file f => LIB_CLASSES
end

file MODEL_JAR => MODEL_SRC_JAR do |t|
  cp MODEL_SRC_JAR, MODEL_JAR
end

appengine_app :app, 'app', '' => APP_CLASSES+LIB_CLASSES

#there is an upload task in appengine_tasks, but I couldn't get it to work
desc "publish to appengine"
task :publish => 'compile:app' do
  sh "appcfg.sh update ."
end

namespace :compile do
  task :app => APP_CLASSES

  task :java => OUTDIR do
    ant.javac :srcdir => 'lib', :destdir => OUTDIR, :classpath => CLASSPATH
  end

end

desc "compile app"
task :compile => 'compile:app'

desc "run development server"
task :server

task :default => :server

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
