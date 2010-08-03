import java.io.FileInputStream
import java.util.Properties
import java.lang.System
import java.io.File

class AssetTimestampsCache
  def initialize
    @properties_file = "config/asset.properties"
    @props = Properties.new
    begin
      @props.load(FileInputStream.new(@properties_file))
    rescue
      # just use in-memory cache
    end
  end

  def get(key:String)
    if @props.getProperty(key) 
      "#{key}?#{@props.getProperty(key)}"
    else
      begin
        milis = String.valueOf(System.currentTimeMillis)
        @props.setProperty(key, milis.substring(0,10))
      rescue
        @props.setProperty(key, "FAILURE") # indicate a problem
      end
      "#{key}?#{@props.getProperty(key)}"
    end
  end
end
