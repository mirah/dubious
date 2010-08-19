require 'rake/clean'

begin
  require 'ant'
rescue LoadError
  puts 'This Rakefile requires JRuby. Please use jruby -S rake.'
  exit 1
end

if ENV['MIRAH_HOME'] && File.exist?(ENV['MIRAH_HOME'] +'/lib/mirah.rb')
  $: << File.expand_path(ENV['MIRAH_HOME'] +'/lib')
end

if File.exist?('../bitescript/lib/bitescript.rb')
   $: << File.expand_path('../bitescript/lib/')
end

require 'mirah_task'

OUTDIR = File.expand_path 'build'
SRCDIR = File.expand_path 'src'

def class_files_for files
  files.map do |f|
    explode = f.split('/')[1..-1]
    explode.last.gsub!(/(^[a-z]|_[a-z])/) {|m|m.sub('_','').upcase}
    explode.last.sub! /\.(duby|java|mirah)$/, '.class'
    OUTDIR + '/' + explode.join('/')
  end
end

#MODEL_JAR = "#{OUTDIR}/dubydatastore.jar"
LIB_MIRAH_SRC = Dir["src/**/*.duby"]
LIB_JAVA_SRC  = Dir["src/**/*.java"]
LIB_SRC = LIB_MIRAH_SRC + LIB_JAVA_SRC
LIB_CLASSES = class_files_for LIB_SRC
STDLIB_CLASSES= LIB_CLASSES.select{|l|l.include? 'stdlib'}

Duby.dest_paths << OUTDIR
Duby.source_paths << SRCDIR
Duby.compiler_options << '--classpath' << [File.expand_path(OUTDIR), *FileList["lib/*.jar", "javalib/*.jar"].map{|f|File.expand_path(f)}].join(':')


file "#{OUTDIR}/dubious/Inflection.class" => :'compile:java'
file "#{OUTDIR}/dubious/ScopedParameterMap.class" => :'compile:java'
file "#{OUTDIR}/dubious/ActionController.class" => ["#{OUTDIR}/dubious/Params.class",
                                                    "#{OUTDIR}/dubious/FormHelper.class", 
                                                    "#{OUTDIR}/dubious/AssetTimestampsCache.class"]
file "#{OUTDIR}/dubious/Inflections.class" => "#{OUTDIR}/dubious/TextHelper.class"
file "#{OUTDIR}/dubious/FormHelper.class" => [
     					      "#{OUTDIR}/dubious/Inflections.class",
     					      "#{OUTDIR}/dubious/InstanceTag.class",
					      "#{OUTDIR}/dubious/TimeConversion.class",
					      *STDLIB_CLASSES]
file "#{OUTDIR}/dubious/InstanceTag.class" => "#{OUTDIR}/dubious/SanitizeHelper.class"
file "#{OUTDIR}/dubious/Params.class" => "#{OUTDIR}/dubious/ScopedParameterMap.class"


file "lib/dubious.jar" => LIB_CLASSES do
  includes =  FileList[OUTDIR+'/dubious/**/*', OUTDIR+'/stdlib/**/*', OUTDIR + '/testing/**/*'].map {|d|d.sub "#{OUTDIR}/",''}.join(',')
  ant.jar :destfile => "lib/dubious.jar", 
          :basedir => OUTDIR,
          :includes => includes
end

desc "compiles mirah & java lib files"
task :compile => LIB_CLASSES

desc "compiles jar for gemification"
task :jar => "lib/dubious.jar"

namespace :compile do
  task :dubious => "lib/dubious.jar"
  task :java => OUTDIR do
    ant.javac :srcdir => SRCDIR, 
    	      :destdir => OUTDIR, 
	      :classpath => CLASSPATH
  end
end


require 'mirah/appengine_tasks'

CLEAN.include(OUTDIR)
CLOBBER.include("lib/dubious.jar")

CLASSPATH = [AppEngine::Rake::SERVLET, AppEngine::SDK::API_JAR].join(":")

directory OUTDIR

(LIB_CLASSES).zip(LIB_SRC).each do |klass,src|
  file klass => src
end


MIRAH_HOME = ENV['MIRAH_HOME'] ? ENV['MIRAH_HOME'] : Gem.find_files('mirah').first.sub(/lib\/mirah.rb/,'')
 
#MODEL_SRC_JAR =  File.join(MIRAH_HOME, 'examples', 'appengine', 'war',
#                                 'WEB-INF', 'lib', 'dubydatastore.jar')
#
#file MODEL_JAR => [ 'build', MODEL_SRC_JAR] do |t|
#  cp MODEL_SRC_JAR, MODEL_JAR
#end

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
