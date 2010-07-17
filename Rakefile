require 'rake/clean'
#require 'mirah'
#require 'mirah/appengine_tasks'

#appengine_app :app


SDK_DIR="/usr/local/appengine-java-sdk-1.3.5"
ENV['APPENGINE_JAVA_SDK']=SDK_DIR
SERVLET="#{SDK_DIR}/lib/shared/geronimo-servlet_2.5_spec-1.2.jar"

OUTDIR=File.expand_path 'build'
WEB_INF_LIB= File.expand_path 'WEB-INF/lib'

SDK_API="#{WEB_INF_LIB}/appengine-api-1.0-sdk-1.3.5.jar"
LABSJAR="#{WEB_INF_LIB}/user/appengine-api-labs-1.3.5.jar"
DBMODEL="#{WEB_INF_LIB}/dubydatastore.jar"
CP=[SERVLET,SDK_API,OUTDIR,DBMODEL,'.'].join ':'

CLEAN.include(OUTDIR)
CLOBBER.include("#{WEB_INF_LIB}/*.jar", 'WEB-INF/appengine-generated')

def class_files_for files
  files.map{ |f|
    explode = f.split('/')[1..-1]
    explode.last.gsub!(/(^[a-z]|_[a-z])/) {|m|m.sub('_','').upcase}
    explode.last.sub! /\.(duby|java|mirah)$/, '.class'
    OUTDIR.split('/').last + '/' + explode.join('/')
  }
end

APP_SRC = Dir["app/**/*.duby"]
APP_CLASSES = class_files_for APP_SRC
APP_MODEL_CLASSES = APP_CLASSES.select {|app| app.include? '/models' }
APP_CONTROLLER_CLASSES = APP_CLASSES.select {|app| app.include? '/controllers' }

LIB_MIRAH_SRC = Dir["lib/**/*.duby"]
LIB_JAVA_SRC  = Dir["lib/**/*.java"]
LIB_SRC = LIB_MIRAH_SRC + LIB_JAVA_SRC
LIB_CLASSES = class_files_for LIB_SRC
STDLIB_CLASSES= LIB_CLASSES.select{|l|l.include? 'stdlib'} 

(LIB_SRC+APP_SRC).zip(LIB_CLASSES+APP_CLASSES).each do |src,obj|
  file obj => src do |t|
    m = t.prerequisites.find{ |s| s =~ /.*\.(duby|mirah)$/}
    Dir.chdir src.split('/').first do
      if m
	mirahc m.pathmap.sub /^[^\/]+\//,''
      else
	javac t.prerequisites.first.sub /^[^\/]+\//,''
      end
    end
  end
end

file "build/dubious/ActionController.class" => ["build/dubious/Params.class","build/dubious/FormHelper.class"]
file "build/dubious/Inflections.class" => "build/dubious/Inflection.class"
file "build/dubious/FormHelper.class" => ["build/dubious/Inflections.class",*STDLIB_CLASSES]
file "build/dubious/Params.class" => "build/dubious/ScopedParameterMap.class"
APP_CONTROLLER_CLASSES.each do |f|
  file f => APP_MODEL_CLASSES
end

def mirahc source
  sh "mirahc -c #{CP} -d #{OUTDIR} #{source}"
end

def mirahc_j src
  "mirahc -c #{CP} -j #{src}"
end

def javac source
  sh "javac -classpath #{CP} -d #{OUTDIR} #{source}"
end

desc "starts the dev server"
task :server do
  sh "dev_appserver.sh -a 0.0.0.0 ."
end

task :init do
  mkdir_p OUTDIR
  mkdir_p WEB_INF_LIB
  sh 'script/environment.rb'
end

#file 'build/dubious/ActionController.class' => 

namespace :compile do
  task :app => [:dubious, *APP_CLASSES]
  task :dubious => [:init, *LIB_CLASSES]
end

desc "compile app"
task :compile => 'compile:app'

task 'build/models/*' => 'compile:app'
task 'build/controllers/*' => 'compile:app'

task 'build/testing/*' => 'compile:dubious'
task 'build/dubious/*' => 'compile:dubious'
task 'build/stdlib/*'  => 'compile:dubious'

JARS = {  "#{WEB_INF_LIB}/application.jar" => FileList['models/*','controllers/*'],
      "#{WEB_INF_LIB}/dubious.jar" => FileList['testing/*','dubious/*','stdlib/*']
}

desc "creates jars"
task :jars => :compile do
  Dir.chdir OUTDIR do   
    JARS.each do |jar,deps|
      sh "jar -cf #{jar} #{deps.join(' ')}"
    end
  end
end

desc "publish to app engine"
task :publish => :jars do
  sh "appcfg.sh update ."
end

task :app => :jars
task :default => :server