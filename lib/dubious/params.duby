import javax.servlet.http.*


class Params
  def initialize(request:HttpServletRequest, response:HttpServletResponse)
    @request = request
    @response = response
    path_info = request.getPathInfo || "/"
    uri_parts = path_info.substring(1, path_info.length).split('/')
    @controller = request.getServletPath
    @action = @id = "" # initialize as String
    if uri_parts.length == 0
      # index
    elsif uri_parts[0].matches("^\\d+$")
      @id = uri_parts[0]
      if uri_parts.length > 1
        @action = uri_parts[1]
      else
        @action = 'show'
      end
    else 
      @action = uri_parts[0]
    end
  end

  def request
    @request
  end

  def response
    @response
  end

  def controller
    @controller
  end

  def action
    return nil if @action.equals("")
    @action
  end

  def id
    val = @id.equals("") ? "0" : @id
    Long.parseLong(val)
  end
end
