require 'appengine-sdk'
require 'mirah_task'
require 'java'
require 'open-uri'
require 'rake'
require 'yaml'

module AppEngine::Rake
  SERVLET = AppEngine::SDK::SDK_ROOT + '/lib/shared/servlet-api.jar'
  APIS = AppEngine::SDK::API_JAR
  TOOLS = AppEngine::SDK::TOOLS_JAR

  $CLASSPATH << SERVLET
  $CLASSPATH << APIS
  $CLASSPATH << TOOLS

  class AppEngineTask < Rake::Task
    def initialize(*args, &block)
      super
      AppEngineTask.tasks << self
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
      Mirah.source_paths << src
      Mirah.dest_paths << webinf_classes
      directory(webinf_classes)
      directory(webinf_lib)

      file_create api_jar => webinf_lib do
        puts 'Copying api jars'
        cp APIS, api_jar
      end

      task :server => [name] do
        check_for_updates
        args = [
          'java', '-cp', TOOLS,
          'com.google.appengine.tools.KickStart',
          'com.google.appengine.tools.development.DevAppServerMain',
          @war]
        system *args
        @done = true
        @update_thread.join
      end

      desc "publish to appengine"
      task :upload => ['compile:app', name] do
        Java::ComGoogleAppengineToolsAdmin::AppCfg.main(
            ['update', @war].to_java(:string))
      end

      enhance([api_jar])
    end

    def real_prerequisites
      prerequisites.map {|n| application[n, scope]}
    end

    def check_for_updates
      @update_thread = Thread.new do
        # Give the server time to start
        next_time = Time.now + 5
        until @done
          sleep_time = next_time - Time.now
          sleep(sleep_time) if sleep_time > 0
          next_time = Time.now + 1
          update
        end
      end
    end

    def update
      begin
        timestamp = app_yaml_timestamp
        @last_app_yaml_timestamp ||= timestamp
        updated = false
        names = real_prerequisites.select {|r|r.needed?}.map &:name
        real_prerequisites.each do |dep|
          if dep.needed?
            puts "Executing #{dep.name}"
            dep.execute
            updated = true
          end
        end
        if updated || (timestamp != @last_app_yaml_timestamp)
          begin
            open('http://localhost:8080/_ah/reloadwebapp')
            @last_app_yaml_timestamp = timestamp
          rescue OpenURI::HTTPError
          end
        end
      rescue Exception
        puts $!, $@
      end
    end

    def app_yaml_timestamp
      if File.exist?(app_yaml)
        File.mtime(app_yaml)
      end
    end

    def app_yaml
      @war + '/WEB-INF/app.yaml'
    end

    def webinf_classes
      @war + '/WEB-INF/classes'
    end

    def webinf_lib
      @war + '/WEB-INF/lib'
    end

    def api_jar
      File.join(webinf_lib, File.basename(APIS))
    end

    def webinf_lib_jars
      Dir.glob(webinf_lib + '/*.jar')
    end
  end
end

def appengine_app(name,src,hash={}, &block)
  war = hash.keys.first
  deps = hash[war] || []
  
  task = AppEngine::Rake::AppEngineTask.define_task(name => deps, &block)
  src = File.expand_path(src || 'src')
  war = File.expand_path(war || 'war')
  task.init(src, war)
  task
end

# sets mirah compile opts
# @param [Hash] opts
# @option opts [String] :dest_path
# @option opts [Array<String>] :source_paths
# @option opts [Array<String>] :compiler_options commandline style options
def mirah_compile_options opts
  Mirah.dest_paths << opts[:dest_path]
  Mirah.source_paths.unshift *opts[:source_paths]
  Mirah.compiler_options.push *opts[:compiler_options]
end

if JRUBY_VERSION < "1.5.6"
  def mirahc *files
    if files[-1].kind_of?(Hash)
      options = files.pop
    else
      options = {}
    end
    source_dir = options.fetch(:dir, Mirah.source_path)
    dest = File.expand_path(options.fetch(:dest, Mirah.dest_path))
    files = files.map {|f| f.sub(/^#{source_dir}\//, '')}
    flags = options.fetch(:options, Mirah.compiler_options)
    args = ['-d', dest, *flags] + files
    chdir(source_dir) do
      cmd = "mirahc #{args.join ' '}"
      puts cmd
      if files.any? {|f|f.include? 'controllers'}
        system cmd
      else
        Mirah.compile(*args)
        Mirah.reset
      end
    end
  end
end

SERVLET_JAR = File.join(AppEngine::SDK::SDK_ROOT, *%w{lib shared servlet-api.jar})

unless $CLASSPATH.include? SERVLET_JAR
  $CLASSPATH << SERVLET_JAR
end

CLASSPATH = [SERVLET_JAR, AppEngine::SDK::API_JAR].join(":")

MODEL_SRC_JAR = File.dirname(Gem.find_files('dubious.rb').first) + '/../javalib/mirahdatastore.jar'

MIRAH_HOME = ENV['MIRAH_HOME'] ? ENV['MIRAH_HOME'] : Gem.find_files('mirah').first.sub(/lib\/mirah.rb/,'')

task :publish => :upload

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
