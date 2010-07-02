#!/usr/bin/ruby
require 'fileutils'
require 'time'

# fetch some information from git to stash at build time

def git_data(dir)
  FileUtils.cd dir
  # ["commit abc....123", "2010-06-23 12:58:06 -0700"]
  IO.popen("git rev-list --pretty=format:%ci -1 HEAD") do |f|
    [f.gets.chomp, f.gets.chomp]
  end
end

data_jar = File.expand_path(File.join(File.dirname(__FILE__),
    '..', 'WEB-INF', 'lib', 'dubydatastore.jar'))
conf_dir = File.expand_path(File.join(File.dirname(__FILE__),
     '..', 'config'))
prop_file = File.join(conf_dir, 'build.properties')
duby_cmd = IO.popen("which duby") { |f| f.gets.chop }
duby_dir = File.join(File.dirname(duby_cmd), '..')
duby_data = git_data(duby_dir)
bite_dir = File.join(duby_dir, '..', 'bitescript')
bite_data = git_data(bite_dir)
data_src = File.join(duby_dir, 'examples', 'appengine', 'war',
                               'WEB-INF', 'lib', 'dubydatastore.jar')
FileUtils.cp(data_src, data_jar) unless File.exists?(data_jar)

properties = <<EOF
# the current build environment
application.build.time=#{Time.now.xmlschema}
duby.version.commit=#{duby_data[0][7..-1]}
duby.version.time=#{Time.parse(duby_data[1]).xmlschema}
bitescript.version.commit=#{bite_data[0][7..-1]}
bitescript.version.time=#{Time.parse(bite_data[1]).xmlschema}
EOF
File.open(prop_file, 'w') {|f| f.write(properties) }
