import javax.servlet.http.HttpServletRequest
import com.google.appengine.api.datastore.Key
import com.google.appengine.api.datastore.KeyFactory


class Params
  def initialize(request:HttpServletRequest, layout:String)
    routes = layout.split('/')
    path = request.getPathInfo || "/"
    slices = String[16] # max number
    parts = path.split('/')
    parts.length.times {|i| slices[i] =  parts[i] }
    @controller = request.getServletPath
    @action = @key = @id = "";
    routes.length.times do |i| 
      @action  = slices[i] || "" if routes[i].equals('action')
      @key     = slices[i] || "" if routes[i].equals('key')
      @id      = slices[i] || "" if routes[i].equals('id')
    end
  end

  def controller
    @controller
  end

  def action
    return nil if @action.equals("")
    @action
  end

  def key
    return nil if @key.equals("")
    KeyFactory.stringToKey(String(@key))
  end

  def key_to_s
    return nil if @key.equals("")
    KeyFactory.keyToString(Key(key))
  end

  def id
    return nil if @id.equals("")
    @id
  end
end
