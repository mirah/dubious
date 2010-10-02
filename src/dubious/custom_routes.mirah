import java.io.FileInputStream
import java.util.Properties
import java.lang.System

class CustomRoutes 
  def initialize; returns :void
    @props = Properties.new
    begin
      @props.load(FileInputStream.new("config/routes.properties"))
    rescue
      # no file, no custom routes
    end
  end

  def get(key:String)
    @props.getProperty(key)
  end
end
