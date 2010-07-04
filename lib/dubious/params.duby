import javax.servlet.http.HttpServletRequest
import com.google.appengine.api.datastore.Key
import com.google.appengine.api.datastore.KeyFactory


class Params
  def initialize(request:HttpServletRequest, layout:String)
    uri = request.getRequestURI
    keys = layout.split('/')
    @controller = request.getServletPath
    slices = uri.substring(@controller.length, uri.length).split('/')
    i = 0
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
    KeyFactory.stringToKey(@encoded) 
  end

  def id
    @id
  end
end
