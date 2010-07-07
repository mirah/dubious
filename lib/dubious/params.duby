import javax.servlet.http.HttpServletRequest
import com.google.appengine.api.datastore.Key
import com.google.appengine.api.datastore.KeyFactory


class Params
  def initialize(request:HttpServletRequest)
    path_info = request.getPathInfo || "/"
    uri_parts = path_info.substring(1, path_info.length).split('/')
    @controller = request.getServletPath
    @action = @id = "";
    if uri_parts.length == 0
      # index when both nil
    elsif uri_parts[0].matches("^\\d+$")
      @id = uri_parts[0]
      @action = uri_parts[1] if uri_parts.length > 1
    else 
      @action = uri_parts[0]
    end
  end

  def controller
    @controller
  end

  def action
    return nil if @action.equals("")
    @action
  end

  def id
    return nil if @id.equals("")
    @id
  end

  def key(kind:String)
    return nil if @id.equals("")
    KeyFactory.createKey(kind, Integer.parseInt(@id))
  end
end
