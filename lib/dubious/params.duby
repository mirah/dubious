import javax.servlet.http.HttpServletRequest

class Params
  def initialize(request:HttpServletRequest, layout:String)
    uri = request.getRequestURI
    keys = layout.split('/')
    @controller = request.getServletPath
    slices = uri.substring(@controller.length, uri.length).split('/')
    i = 0
    while i < keys.length
      @action = slices[i] || nil if keys[i].equals('action')
      @id     = slices[i] || nil if keys[i].equals('id')
    end
  end

  def controller
    returns String
    @controller
  end

  def action
    returns String
    @action
  end

  def id
    returns String
    @id
  end
end
