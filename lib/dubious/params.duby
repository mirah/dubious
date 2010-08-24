import javax.servlet.http.HttpServletRequest
import java.util.HashMap
import java.util.Map

class Params
  def initialize(request:HttpServletRequest)
    @request = request
    path_info = request.getPathInfo || "/"
    uri_parts = path_info.substring(1, path_info.length).split('/')
    @controller = request.getServletPath
    @action = @id = "" # initialize as String
    @params = HashMap.new
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

  # uri slices

  def controller
    @controller
  end

  def action
    @action
  end

  def id
    @id.equals("") ? long(0) : Long.parseLong(@id)
  end

  #  request helpers

  def request
    @request
  end

  # query params

  def get(name:String)
    values = array(name)
    values[0] if values && values.length > 0
  end

  def array(name:String)
    @request.getParameterValues(name)
  end

  def for(model:String)
    ScopedParameterMap.params(request, model)
  end

  # path helpers

  def index
    "#{@controller}"
  end

  def new
    "#{@controller}/new"
  end

  def show
    show(id)
  end

  def show(id:long)
    "#{@controller}/#{String.valueOf(id)}"
  end

  def edit
    edit(id)
  end

  def edit(id:long)
    "#{@controller}/#{String.valueOf(id)}/edit"
  end
end
