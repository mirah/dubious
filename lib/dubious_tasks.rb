require 'mirah/appengine_tasks'

if JRUBY_VERSION < "1.5.6"
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
end

CLASSPATH = [AppEngine::Rake::SERVLET, AppEngine::SDK::API_JAR].join(":")

MIRAH_HOME = ENV['MIRAH_HOME'] ? ENV['MIRAH_HOME'] : Gem.find_files('mirah').first.sub(/lib\/mirah.rb/,'')

MODEL_SRC_JAR =  File.join(MIRAH_HOME, 'examples', 'appengine', 'war',
                                 'WEB-INF', 'lib', 'dubydatastore.jar')

#there is an upload task in appengine_tasks, but I couldn't get it to work
desc "publish to appengine"
task :publish => 'compile:app' do
  sh "appcfg.sh update ."
end

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
