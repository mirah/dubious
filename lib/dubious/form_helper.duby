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
    @date_formatter = TimeConversion.new('jsdate')
    @time_formatter = TimeConversion.new('clock')
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
    hm1 = {:action => @action, :method => "post"}
    hm1.put('id', "#{@params.action}_#{@kind}")
    hm1.put('class', @params.action)
    hm2 = HashMap.new; hm2.put('style', "margin:0;padding:0;display:inline")
    hm3 = {:name => "authenticity_token", :type => "hidden"}
    hm3.put('value', @token)
    @t.tag("form", hm1, true) + method + @t.tag("div", hm2, true) +
    @t.tag("input", hm3) + "</div>"
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
    "<!-- unsupported -->"
  end

  def check_box(name:String, html_options:HashMap)
    add_default_name_and_id(name, html_options)
    html_options.put('type', 'checkbox')
    html_options.put('value', 'TRUE') unless html_options.containsKey('value')
    html_options.put('checked', 'checked') if Boolean(@a.get(name)).booleanValue
    @t.tag("input", html_options)
  end

  def check_box(name:String)
    check_box(name, HashMap.new)
  end

  def fields_for(name:String, html_options:HashMap)
    "<!-- unsupported -->"
  end

  def fields_for(name:String)
    fields_for(name, HashMap.new)
  end

  def file_field(name:String, html_options:HashMap)
    add_default_name_and_id(name, html_options)
    html_options.put('type', 'file')
    @t.tag("input", html_options)
  end

  def file_field(name:String)
    file_field(name, HashMap.new)
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

  def radio_button(name:String, value:String, html_options:HashMap)
    add_default_name_and_id(name, value, html_options)
    html_options.put('type', 'radio')
    html_options.put('value', value)
    html_options.put('checked', 'checked') if value.equals(String(@a.get(name)))
    @t.tag("input", html_options)
  end

  def radio_button(name:String, value:String)
    radio_button(name, value, HashMap.new)
  end

  def text_area(name:String, html_options:HashMap)
    add_default_name_and_id(name, html_options)
    html_options.put('cols', '40') unless html_options.containsKey('cols')
    html_options.put('rows', '20') unless html_options.containsKey('rows')
    value = String(@a.get(name)) || "" # convert Text to String
    @t.content_tag("textarea", value , html_options)
  end

  def text_area(name:String)
    text_area(name, HashMap.new)
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
    html_options.put('value', @date_formatter.format(Date(@a.get(name))))
    js = "$(function() { $(\"##{@kind}_#{name}\").datepicker(); });"
    hm = HashMap.new; hm.put('type', "text/javascript")
    @t.content_tag("script", js, hm, false, false) +
    @t.tag("input", html_options)
  end

  def date_select(name:String)
    date_select(name, HashMap.new)
  end

  def time_select(name:String, html_options:HashMap)
    add_default_name_and_id(name, html_options)
    html_options.put('type', 'text')
    html_options.put('size', '10') unless html_options.containsKey('size')
    html_options.put('value', @time_formatter.format(Date(@a.get(name))))
    @t.tag("input", html_options)
  end

  def time_select(name:String)
    time_select(name, HashMap.new)
  end

  # consider: http://wiki.jqueryui.com/TimePicker

  private

  def add_default_name_and_id(name:String, sub:String, html_options:HashMap)
    returns :void
    key = sub.nil? ? name: "#{name}_#{sub}"
    html_options.put('id', "#{@kind}_#{key}")
    html_options.put('name', "#{@kind}[#{name}]")
  end

  def add_default_name_and_id(name:String, html_options:HashMap)
    add_default_name_and_id(name, nil, html_options)
  end
end

