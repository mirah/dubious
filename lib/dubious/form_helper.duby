import com.google.appengine.ext.duby.db.Model
import java.lang.StringBuilder
import dubious.TimeConversion
import dubious.InstanceTag
import java.util.List
import java.util.HashMap
import stdlib.Array
import java.util.Date

class FormHelper
  def initialize(model:Model, params:Params)
    @t = InstanceTag.new
    @a = model.properties
    @kind = model.kind.toLowerCase
    @params = params
    @method = params.action.equals('edit') ? 'put' : 'post'
    @action = params.action.equals('edit') ? params.show : params.index
    @formatter = TimeConversion.new('jsdate')
    @token = '333313d4774617f95de1'
    @dsize = '30'
  end

  def select(name:String, choices:List, html_options:HashMap)
    add_default_name_and_id(name, html_options)
    options = StringBuilder.new
    selected = @a.get(name) || ""
    choices.each do |s|
      opts = {'value' => s} # TODO: support pairs
      opts.put('selected', "selected") if String(s).equals(selected)
      options.append @t.content_tag("option", String(s), opts)
    end
    @t.content_tag("select", options.toString, html_options, false, false)
  end

  def select(name:String, choices:List)
    select(name, choices, HashMap.new)
  end

  def start_form
    method = ["get" ,"post"].contains(@method) ? "" : @t.tag("input",
        :name => "_method", :type => "hidden", :value => @method)
    h1 = {:action => @action, :method => "post"}
    h1.put('id', "#{@params.action}_#{@kind}")
    h1.put('class', @params.action)
    h2 = HashMap.new; h2.put('style', "margin:0;padding:0;display:inline")
    h3 = {:name => "authenticity_token", :type => "hidden"}
    h3.put('value', @token)
    @t.tag("form", h1, true) + method + @t.tag("div", h2, true) +
    @t.tag("input", h3) + "</div>"
  end

  def end_form
    "</form>"
  end

  def submit(name:String)
    @commit = @params.action.equals('edit') ? 'Update' : 'Create'
    options = {:name => "commit", :type => "submit", :value => @commit}
    options.put('id', "#{@kind}_submit")
    @t.tag("input", options)
  end

  def error_messages
    "<!-- soon -->"
  end

  def check_box(name:String)
    "<!-- soon -->"
  end

  def fields_for(name:String, html_options:HashMap)
    add_default_name_and_id(name, html_options)
    html_options.put('type', 'text')
    html_options.put('size', @dsize) unless html_options.containsKey('size')
    html_options.put('value', @a.get(name) || "")
    @t.tag("input", html_options)
  end

  def fields_for(name:String)
    fields_for(name, HashMap.new)
  end

  def file_field(name:String)
    "<!-- soon -->"
  end

  def hidden_field(name:String)
    html_options = HashMap.new
    html_options.put('type', 'hidden')
    add_default_name_and_id(name, html_options)
    html_options.put('value', @a.get(name) || "")
    @t.tag("input", html_options)
  end

  def label(name:String, html_options:HashMap)
    html_options.put('for', "#{@kind}_#{name}")
    html_options.put('value', @a.get(name) || "")
    @t.content_tag("label", Inflections.titleize(name), html_options)
  end

  def label(name:String)
    label(name, HashMap.new)
  end

  def password_field(name:String, html_options:HashMap)
    add_default_name_and_id(name, html_options)
    html_options.put('type', 'password')
    html_options.put('size', @dsize) unless html_options.containsKey('size')
    html_options.put('value', @a.get(name) || "")
    @t.tag("input", html_options)
  end

  def password_field(name:String)
    password_field(name, HashMap.new)
  end

  def radio_button(name:String)
    "<!-- soon -->"
  end

#  def text_area(name:String, html_options:HashMap)
#    add_default_name_and_id(name, html_options)
#    html_options.put('cols', '40') unless html_options.containsKey('cols')
#    html_options.put('rows', '20') unless html_options.containsKey('rows')
#    value = @a.get(name) || ""
#    @t.content_tag("textarea", value, html_options)
#  end

#  def text_area(name:String)
#    text_area(name, HashMap.new)
#  end

  def text_area(name:String)
    return <<EOF
<textarea cols="40" id="#{@kind}_#{name}" name="#{@kind}[#{name}]" rows="20">#{@a.get(name) || ""}</textarea> 
EOF
  end

  def text_field(name:String, html_options:HashMap)
    add_default_name_and_id(name, html_options)
    html_options.put('type', 'text')
    html_options.put('size', @dsize) unless html_options.containsKey('size')
    html_options.put('value', @a.get(name) || "")
    @t.tag("input", html_options)
  end

  def text_field(name:String)
    text_field(name, HashMap.new)
  end

  def date_select(name:String, html_options:HashMap)
    add_default_name_and_id(name, html_options)
    html_options.put('type', 'text')
    html_options.put('size', '10') unless html_options.containsKey('size')
    html_options.put('value', @formatter.format(Date(@a.get(name))))
    js = <<JS
$(function() { $("##{@kind}_#{name}").datepicker(); });
JS
    hm = HashMap.new; hm.put('type', "text/javascript")
    @t.content_tag("script", js, hm, false, false) +
    @t.tag("input", html_options)
  end

  def date_select(name:String)
    date_select(name, HashMap.new)
  end

  def time_select(name:String)
    "<!-- soon -->"
  end

  private

  def add_default_name_and_id(name:String, map:HashMap) returns :void
    map.put('id', "#{@kind}_#{name}")
    map.put('name', "#{@kind}[#{name}]")
  end
end
