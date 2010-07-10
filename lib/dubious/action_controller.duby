import javax.servlet.http.*
import java.util.regex.Pattern
import java.util.HashMap
import dubious.Params
import java.io.File

class ActionController < HttpServlet

  def index;  returns :void; end
  def show;   returns :void; end
  def new;    returns :void; end
  def edit;   returns :void; end
  def delete; returns :void; end
  def create; returns :void; end
  def update; returns :void; end

  def params; returns Params
    @params
  end

  def yield_body(content:String); returns :void
    @yield_str = content
  end

  def yield_body
    @yield_str
  end

  def flash_notice(content:String); returns :void
    @flash_str = content
  end

  def flash_notice
    @flash_str || ""
  end

  def render(content:String); returns :void
    @response.getWriter.write(content)
  end

  def render(content:String, layout:String); returns :void
    yield_body(content)
    @response.getWriter.write(layout)
  end

  def redirect_to(link:String); returns :void
    @response.sendRedirect(link)
  end

  def action_router(request:HttpServletRequest,
      response:HttpServletResponse, method:String); returns :void
    method = request.getParameter('_method') || method
    @response = response
    @params = Params.new(request)
    if method.equals('get')
      response.setContentType("text/html; charset=UTF-8")
      if @params.action.equals("")
        index
      elsif @params.action.equals('show')
        show
      elsif @params.action.equals('new')
        new
      elsif @params.action.equals('edit')
        edit
      else
        redirect_to "/404.html"
      end
    else
      if invalid_authenticity_token request.getParameter('authenticity_token')
        redirect_to "/422.html"
      elsif method.equals('delete')
        delete
      elsif method.equals('post')
        create
      elsif method.equals('put')
        update
      end
    end
  end

  def invalid_authenticity_token(token:String) # TODO
    token.equals("") ? true : false
  end

  ###
  # ActionView::Helpers::UrlHelper
  #
  # button_to
  # current_page?
  # link_to
  def link_to(name:String, options:String)
     "<a href=\"#{options}\">#{name}</a>"
  end
  def link_to(name:String, map:HashMap)
    sb = StringBuilder.new("<a")
    map.keySet.each { |key| sb.append(" #{key}=\"#{map.get(key)}\"") }
    sb.append(">#{name}</a>")
    sb.toString
  end
  # link_to_if
  # link_to_unless
  # link_to_unless_current
  # mail_to
  # url_for

  ###
  # ActionView::Helpers::AssetTagHelper
  #
  # auto_discovery_link_tag
  # cache_asset_timestamps
  # cache_asset_timestamps=
  # image_path
  # image_tag
  def javascript_include_tag(text:String)
    src = text.startsWith("http") ? text : "/javascripts/#{text}"
    src += ".js" unless src.endsWith(".js")
    src += "?#{File.new("public#{src}").lastModified}" unless
        src.startsWith("http")
    "<script src=\"#{src}\" type=\"text/javascript\"></script>"
  end
  # javascript_path
  # path_to_image
  # path_to_javascript
  # path_to_stylesheet
  # register_javascript_expansion
  # register_javascript_include_default
  # register_stylesheet_expansion
  def stylesheet_link_tag(text:String)
    stamp = File.new("public/stylesheets/#{text}.css").lastModified
    "<link href=\"/stylesheets/#{text}.css?#{stamp}\" " +
    'media="screen" rel="stylesheet" type="text/css" />'
  end
  # stylesheet_path


  ###
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
