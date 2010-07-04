import javax.servlet.http.HttpServlet
import java.io.File
import java.util.HashMap
import java.util.regex.Pattern
import com.google.appengine.ext.duby.db.Model

class ActionController < HttpServlet

  ###
  # ActionView::Helpers::UrlHelper
  #
  # button_to
  # current_page?
  # link_to
  def link_to(name:String, options:String)
     "<a href='#{options}'>#{name}</a>" # TODO
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
    stamp = File.new("public/javascripts/#{text}.js").lastModified()
    "<script src=\"/javascripts/#{text}.js?#{stamp}\" " +
    'type="text/javascript"></script>'
  end
  # javascript_path
  # path_to_image
  # path_to_javascript
  # path_to_stylesheet
  # register_javascript_expansion
  # register_javascript_include_default
  # register_stylesheet_expansion
  def stylesheet_link_tag(text:String)
    stamp = File.new("public/stylesheets/#{text}.css").lastModified()
    "<link href=\"/stylesheets/#{text}.css?#{stamp}\" " +
    'media="screen" rel="stylesheet" type="text/css" />'
  end
  # stylesheet_path


  ###
  # escape special characters

  def self.initialize
    returns void
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
