#!/usr/bin/ruby
require 'fileutils'
require 'time'

prop_file = 'config/asset.properties'

properties = "# cached assests from: #{Time.now}\n"
FileUtils.cd "public"
Dir.glob("**/*").each do |f|
  properties += "/#{f}=#{File.stat(f).mtime.to_i}\n"
end
FileUtils.cd ".."
File.open(prop_file, 'w') {|f| f.write(properties) }
