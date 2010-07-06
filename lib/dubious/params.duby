import javax.servlet.http.HttpServletRequest
import com.google.appengine.api.datastore.Key
import com.google.appengine.api.datastore.KeyFactory


class Params
  def initialize(request:HttpServletRequest, layout:String)
    uri = request.getRequestURI
    keys = layout.split('/')
    @controller = request.getServletPath
    slices = uri.substring(@controller.length, uri.length).split('/')
    @action = nil; @encoded = nil; @id = nil; i = 0
    while i < keys.length
      @action  = slices[i] || nil if keys[i].equals('action')
      @encoded = slices[i] || nil if keys[i].equals('key')
      @id      = slices[i] || nil if keys[i].equals('id')
    end
  end

  def controller
    @controller
  end

  def action
    @action
  end

  def key
    return nil if @encoded.nil?
    KeyFactory.stringToKey(String(@encoded))
  end

  def key_to_s
    return nil if @encoded.nil?
    KeyFactory.keyToString(Key(key))
  end

  def id
    @id
  end
end
