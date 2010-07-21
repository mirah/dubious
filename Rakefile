require 'rake/clean'


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


JARS = {  "#{WEB_INF_LIB}/application.jar" => FileList['models/*','controllers/*'],
      "#{WEB_INF_LIB}/dubious.jar" => FileList['testing/*','dubious/*','stdlib/*']
}


task :init do
  mkdir_p OUTDIR
  mkdir_p WEB_INF_LIB
  sh 'script/environment.rb'
end

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

desc "creates jars"
task :jars => :compile do
  Dir.chdir OUTDIR do   
    JARS.each do |jar,deps|
      sh "jar -cf #{jar} #{deps.join(' ')}"
    end
  end
end


if defined? JRuby
  if  ENV['MIRAH_HOME'] && File.exist?(ENV['MIRAH_HOME'] +'/lib/mirah.rb')
    $: << File.expand_path(ENV['MIRAH_HOME'] +'/lib')
  end

  if File.exist?('../bitescript/lib/bitescript.rb')
     $: << File.expand_path('../bitescript/lib/')
  end

  require 'mirah'
  require 'mirah/appengine_tasks'
  module AppEngine::Rake
    class AppEngineTask < Rake::Task
      def update
	begin
	  timestamp = app_yaml_timestamp
	  @last_app_yaml_timestamp ||= timestamp

	  needed_prereqs = real_prerequisites.select { |dep| dep.needed? }
	  needed_prereqs.each { |dep| dep.execute }

	  updated = !needed_prereqs.empty? || timestamp > @last_app_yaml_timestamp

	  if updated
	    sh "touch #{@war}/WEB-INF/appengine-web.xml"
	    @last_app_yaml_timestamp = timestamp
	  end
	rescue Exception
	  puts $!, $@
	end
      end

      def init(src, war)
	@src = src
	@war = war
	unless $CLASSPATH.include?(webinf_classes)
	  $CLASSPATH << webinf_classes
	end
	webinf_lib_jars.each do |jar|
	  $CLASSPATH << jar unless $CLASSPATH.include?(jar)
	end

	Duby.compiler_options = ['-c',CP]
	Duby.source_path = src
	Duby.dest_path = OUTDIR

	directory(webinf_classes)
	directory(webinf_lib)

	file_create api_jar => webinf_lib do
	  puts 'Coping apis'
	  cp APIS, api_jar
        end
        
        desc "run dev server"
        task :server => [name] do
          check_for_updates
          args = [
	    'java', '-cp', TOOLS,
	    'com.google.appengine.tools.KickStart',
	    'com.google.appengine.tools.development.DevAppServerMain',
	    @war
	  ]
	  sh *args
	  @done = true
	  @update_thread.join
	end

        desc "publish to appengine"
	task :publish => [name] do
	  Java::ComGoogleAppengineTools::AppCfg.main(
	      ['update', @war].to_java(:string))
	end

	enhance([api_jar])
      end
    end
  end

  appengine_app :app, 'app',''
  Rake::Task[:app].enhance(APP_CLASSES)
  task :default => :server

else # if mri

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

  desc "starts the dev server"
  task :server do
    sh "dev_appserver.sh -a 0.0.0.0 ."
  end

  desc "publish to app engine"
  task :publish => :jars do
    sh "appcfg.sh update ."
  end

  task :app => :jars
  task :default => :server  
end