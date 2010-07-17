import com.google.appengine.ext.duby.db.Model
import javax.servlet.http.*
import java.util.regex.Pattern
import java.util.HashMap
import dubious.Params
import dubious.FormHelper
import java.io.File
import java.net.URI

class ActionController < HttpServlet

  # expect URI, String or Integer
  def index;  Object(Integer.valueOf(404)); end
  def show;   Object(Integer.valueOf(404)); end
  def new;    Object(Integer.valueOf(404)); end
  def edit;   Object(Integer.valueOf(404)); end
  def delete; Object(Integer.valueOf(404)); end
  def create; Object(Integer.valueOf(404)); end
  def update; Object(Integer.valueOf(404)); end

  def set_params(params:Params); returns :void
    @params_obj = params
  end

  def params; returns Params
    @params_obj
  end

  def set_flash_notice(content:String); returns :void
    @flash_str = content
  end

  def flash_notice
    @flash_str || ""
  end

  # for simplicity, we split on this token
  def yield_body; "@@_YIELD_BODY_@@"; end

  def render(content:String, layout:String); returns String
    wrapper = layout.split(yield_body)
    if wrapper.length == 2
      wrapper[0] + content + wrapper[1]
    else
       layout + "\n\n<!-- Oops, yield_body missing -->"
    end
  end

  def render(content:String); returns String
    content
  end

  def redirect_to(link:String); returns URI
    URI.new(link)
  end

  # accepts various types, and creates the appropriate response
  def action_response(response:HttpServletResponse, payload:Object)
    returns :void
    if payload.kind_of?(URI)
      location = payload.toString
      if location.startsWith('http') or location.startsWith('/')
        response.sendRedirect(location); nil
      else
        response.setStatus(500) 
        response.getWriter.write("Invalid redirect location")
      end
    elsif payload.kind_of?(String)
      response.setContentType("text/html; charset=UTF-8")
      response.getWriter.write(payload.toString)
    elsif payload.kind_of?(Integer)
      response.setStatus(Integer(payload).intValue) 
      response.sendRedirect("#{payload}.html"); nil
    else
      response.setStatus(500) 
      response.getWriter.write("Unsupported Response Type")
    end
  end

  # route request to the approprite action
  def action_request(request:HttpServletRequest, method:String); returns Object
    set_params Params.new(request)
    method = request.getParameter('_method') || method
    if method.equals('get')
      if params.action.equals("")
        index
      elsif params.action.equals('show')
        show
      elsif params.action.equals('new')
        new
      elsif params.action.equals('edit')
        edit
      else
        Object(Integer.valueOf(404))
      end
    else
      if invalid_authenticity_token request.getParameter('authenticity_token')
        Object(Integer.valueOf(422))
      elsif method.equals('delete')
        delete
      elsif method.equals('post')
        create
      elsif method.equals('put')
        update
      end
    end
  end

  private

  def invalid_authenticity_token(token:String) # TODO
    token.equals("") ? true : false
  end

  public

  def form_for(model:Model)
    FormHelper.new(model, params)
  end

  # ActionView::Helpers::UrlHelper
  #
  # button_to
  # current_page?
  # link_to_if
  # link_to_unless
  # link_to_unless_current
  # mail_to
  # url_for

  def link_to(name:String, options:String)
     "<a href=\"#{options}\">#{name}</a>"
  end

  def link_to(name:String, map:HashMap)
    sb = StringBuilder.new("<a")
    map.keySet.each { |key| sb.append(" #{key}=\"#{map.get(key)}\"") }
    sb.append(">#{name}</a>")
    sb.toString
  end

  # ActionView::Helpers::AssetTagHelper
  #
  # auto_discovery_link_tag
  # cache_asset_timestamps
  # cache_asset_timestamps=
  # image_path
  # image_tag
  # javascript_path
  # path_to_image
  # path_to_javascript
  # path_to_stylesheet
  # register_javascript_expansion
  # register_javascript_include_default
  # register_stylesheet_expansion
  # stylesheet_path

  def javascript_include_tag(text:String)
    src = text.startsWith("http") ? text : "/javascripts/#{text}"
    src += ".js" unless src.endsWith(".js")
    src += "?#{File.new("public#{src}").lastModified}" unless
        src.startsWith("http")
    "<script src=\"#{src}\" type=\"text/javascript\"></script>"
  end

  def stylesheet_link_tag(text:String)
    stamp = File.new("public/stylesheets/#{text}.css").lastModified
    "<link href=\"/stylesheets/#{text}.css?#{stamp}\" " +
    'media="screen" rel="stylesheet" type="text/css" />'
  end

  # escape special characters

  def self.initialize
    returns :void
    @escape_pattern = Pattern.compile("[<>&'\"]")
    @escaped = HashMap.new
    @escaped.put("<", "&lt;")
    @escaped.put(">", "&gt;")
    @escaped.put("&", "&amp;")
    @escaped.put("\"", "&quot;")
    @escaped.put("'", "&#39;")
  end

  def self.html_escape(text:String)
    return "" unless text
    matcher = @escape_pattern.matcher(text)
    buffer = StringBuffer.new
    while matcher.find
      replacement = String(@escaped.get(matcher.group))
      matcher.appendReplacement(buffer, replacement)
    end
    matcher.appendTail(buffer)
    return buffer.toString
  end

  def self.html_escape(o:Object)
    return "" unless o
    html_escape(o.toString)
  end

  def h(text:String)
    ActionController.html_escape(text)
  end

  def h(o:Object)
    ActionController.html_escape(o)
  end
end
