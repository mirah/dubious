import com.google.appengine.ext.duby.db.Model
import javax.servlet.ServletConfig
import javax.servlet.http.*
import java.util.regex.Pattern
import java.util.Arrays
import java.util.HashMap
import java.util.Date
import java.io.File
import java.net.URI
import dubious.*
import stdlib.*

class ActionController < HttpServlet

  # expect URI, String or Integer
  def index;  Object(Integer.valueOf(404)); end
  def show;   Object(Integer.valueOf(404)); end
  def new;    Object(Integer.valueOf(404)); end
  def edit;   Object(Integer.valueOf(404)); end
  def delete; Object(Integer.valueOf(404)); end
  def create; Object(Integer.valueOf(404)); end
  def update; Object(Integer.valueOf(404)); end

  def set_params(params:Params) returns :void
    @params_obj = params
  end

  def params
    @params_obj
  end

  def set_flash_notice(content:String) returns :void
    @flash_str = content
  end

  def flash_notice
    @flash_str || ""
  end

  # for simplicity, we split on this token
  def yield_body; "@@_YIELD_BODY_@@"; end

  def render(content:String, layout:String)
    wrapper = layout.split(yield_body)
    if wrapper.length == 2
      "#{wrapper[0]}#{content}#{wrapper[1]}"
    else
      "#{layout}\n\n<!-- Oops, yield_body missing -->"
    end
  end

  def render(content:String)
    content
  end

  def redirect_to(link:String)
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
  
  def doGet(request, response)
    action_response(response, action_request(request, 'get'))
  end

  def doPost(request, response)
    action_response(response, action_request(request, 'post'))
  end

  # route request to the appropriate action
  def action_request(request:HttpServletRequest, method:String) returns Object
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

  # UrlHelper

  def link_to(value:String, options:HashMap)
    # TODO: parse option :popup
    if String.valueOf(options.get(:method)).equals(:delete)
      options.put(:rel, 'nofollow')
      options.put('data-method', 'delete')
      options.remove(:method) 
      if options.containsKey(:confirm)
        options.put('data-confirm', options.get(:confirm))
        options.remove(:confirm) 
      end
    end
    @instance_tag.content_tag("a", value, options, false, false)
  end

  def link_to(value:String, args:HashMap, options:HashMap)
    # TODO: support additional args ?foo=1&bar=2&baz=3
    url = args.containsKey(:controller) ?
        "/#{args.get(:controller)}" : params.controller
    if args.containsKey(:action)
      url += "/#{args.get(:action)}"
      url += "/#{args.get(:id)}" if args.containsKey(:id)
    end
    options.put(:href, url)
    link_to(value, options)
  end

  def link_to(value:String, url:String, options:HashMap)
    options.put(:href, url)
    link_to(value, options)
  end

  def link_to(value:String, url:String)
    link_to(value, url, HashMap.new)
  end

  # Homage to Merb

  def resource(kind:String, action:String, id:String)
    default = Inflections.pluralize kind.toLowerCase
    custom = @custom_routes.get(default)
    controller = custom ? custom : default 
    if action.equals(:new)
      "/#{controller}/new"
    elsif id.nil? # index
      "/#{controller}"   
    elsif action.equals(:show)
      "/#{controller}/#{id}"
    else
      "/#{controller}/#{id}/#{action}"
    end
  end

  def resource(kind:String, action:String)
    resource(kind, action, nil)
  end

  def resource(kind:String)
    resource(kind, :index, nil)
  end

  def resource(model:Model, action:String)
    resource(model.kind, action, String.valueOf(model.key.getId))
  end

  def resource(model:Model)
    resource(model, :show)
  end

  # AssetTagHelper

  # always use AssetTimestampsCache
  def add_asset_timestamp(source:String)
    @asset_timestamps_cache.get(source)
  end

  def image_path(source:String)
    source = "/images/#{source}" unless source.startsWith('/')
    add_asset_timestamp(source)
  end

  def javascript_path(source:String)
    source += ".js" unless source.endsWith(".js")
    source = "/javascripts/#{source}" unless source.startsWith('/')
    add_asset_timestamp(source)
  end

  def stylesheet_path(source:String)
    source += ".css" unless source.endsWith(".css")
    source = "/stylesheets/#{source}" unless source.startsWith('/')
    add_asset_timestamp(source)
  end

  def image_tag(source:String, options:HashMap)
    source = source.startsWith('http') ? source : image_path(source)
    options.put(:src, source)
    options.put(:alt, "") unless options.containsKey("alt")
    if options.containsKey("size") &&
        String(options.get("size")).matches("\\d+x\\d+")
      values = String(options.get("size")).split("x")
      options.put(:width, values[0])
      options.put(:height, values[1])
      options.remove("size") 
    end
    @instance_tag.tag("img", options)
  end

  def image_tag(source:String)
    image_tag(source, HashMap.new)
  end

  def javascript_include_tag(text:String)
    text = javascript_path(text) unless text.startsWith("http")
    options = Ha.sh [:src, text, :type, "text/javascript"]
    @instance_tag.content_tag("script", "", options)
  end

  def stylesheet_link_tag(text:String)
    text = stylesheet_path(text) unless text.startsWith("http")
    opts = Ha.sh [:href, text, :rel, "stylesheet",
                  :type, "text/css", :media, "screen"]
    @instance_tag.tag("link", opts)
  end

  # init the servlet

  def controller_init; returns :void; end

  def init(config:ServletConfig)
    controller_init
    @asset_timestamps_cache = AssetTimestampsCache.new
    @instance_tag = InstanceTag.new
    @custom_routes = CustomRoutes.new
    @date_formatters = HashMap.new
  end

  # format and parse date

  def date_format(date:Date, token:string = 'terse')
    @date_formatters.put(token, TimeConversion.new(token)) unless @date_formatters.containsKey(token)
    TimeConversion(@date_formatters.get(token)).format(date)
  end

  def date_parse(str:String, token:string = 'terse')
    @date_formatters.put(token, TimeConversion.new(token)) unless @date_formatters.containsKey(token)
    TimeConversion(@date_formatters.get(token)).parse(str)
  end

  # escape special characters

  def h(text:String)
    SanitizeHelper.html_escape(text)
  end

  def h(o:Object)
    SanitizeHelper.html_escape(o)
  end
end
