require 'rubygems'
require 'rubygems/package_task'
require 'rake/clean'
require 'bundler/setup'
Bundler.setup

begin
  require 'ant'
rescue LoadError
  puts 'This Rakefile requires JRuby. Please use jruby -S rake.'
  exit 1
end

Gem::PackageTask.new Gem::Specification.load('dubious.gemspec') do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end

require 'dubious_tasks'

OUTDIR = File.expand_path 'build'
SRCDIR = File.expand_path 'src'

CLEAN.include(OUTDIR)
CLOBBER.include("lib/dubious.jar", "javalib/mirahdatastore.jar")

def class_files_for files
  files.map do |f|
    explode = f.split('/')[1..-1]
    explode.last.gsub!(/(^[a-z]|_[a-z])/) {|m|m.sub('_','').upcase}
    explode.last.sub! /\.(duby|java|mirah)$/, '.class'
    OUTDIR + '/' + explode.join('/')
  end
end

LIB_MIRAH_SRC = Dir["src/**/*{.duby,.mirah}"]
LIB_JAVA_SRC  = Dir["src/**/*.java"]
 
LIB_SRC = LIB_MIRAH_SRC + LIB_JAVA_SRC
LIB_CLASSES = class_files_for LIB_SRC
STDLIB_CLASSES= LIB_CLASSES.select{|l|l.include? 'stdlib'}

mirah_compile_options :compiler_options => ['--classpath', [OUTDIR+'/', SERVLET_JAR,*FileList["lib/*.jar", "javalib/*.jar"].map{|f|File.expand_path(f)}].join(':')],
                      :dest_path => OUTDIR,
                      :source_paths => SRCDIR

file "#{OUTDIR}/dubious/Inflection.class" => :'compile:java'
file "#{OUTDIR}/dubious/ScopedParameterMap.class" => :'compile:java'
file "#{OUTDIR}/dubious/ActionController.class" => ["#{OUTDIR}/dubious/Params.class",
                                                    "#{OUTDIR}/dubious/FormHelper.class", 
                                                    "#{OUTDIR}/dubious/AssetTimestampsCache.class",
						    "#{OUTDIR}/dubious/CustomRoutes.class",
						    ]

file "#{OUTDIR}/dubious/Inflections.class" => [
        "#{OUTDIR}/dubious/TextHelper.class",
      	"#{OUTDIR}/dubious/Inflection.class"
      ]

file "#{OUTDIR}/dubious/TextHelper.class" => [
   			"#{OUTDIR}/dubious/Inflection.class",
      ]

                      
file "#{OUTDIR}/dubious/FormHelper.class" => [
     					      "#{OUTDIR}/dubious/Inflections.class",
     					      "#{OUTDIR}/dubious/InstanceTag.class",
     					      "#{OUTDIR}/dubious/Params.class",
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

desc "pull dependencies"
task :dependencies => 'javalib/mirahdatastore.jar'

file 'javalib/mirahdatastore.jar' do
  cp Gem.find_files('mirahdatastore.jar'), 'javalib/'
end

namespace :compile do
  task :dubious => "lib/dubious.jar"
  task :java => OUTDIR do
    ant.javac :srcdir => SRCDIR, 
    	        :destdir => OUTDIR, 
	            :classpath => CLASSPATH,
              :includeantruntime => true
  end
end

directory OUTDIR

(LIB_CLASSES).zip(LIB_SRC).each do |klass,src|
  file klass => [:dependencies, src]
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
  model_data = git_data(File.dirname(Gem.find_files('mirahdatastore.jar')),'mirahdatastore.jar')

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
