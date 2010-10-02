import dubious.SanitizeHelper
import java.lang.StringBuilder
import java.util.HashMap
import java.util.Arrays

class InstanceTag

  def h(text:String)
    SanitizeHelper.html_escape(text)
  end

  def _tag(name:String, value:String, options:HashMap,
           open:boolean, escape:boolean)
    sb = StringBuilder.new("<#{name}")
    keys = options.keySet.toArray; Arrays.sort(keys)
    keys.each { |k| sb.append(" #{k}=\"#{options.get(k)}\"") }
    if value.nil?
      sb.append(open ? ">" : " />")
    else
      sb.append(">#{escape ? h(value) : value}</#{name}>")
    end
    sb.toString
  end

  def tag(name:String, options:HashMap,
          open:boolean, escape:boolean)
    _tag(name, nil, options, open, escape)
  end

  def tag(name:String, options:HashMap, open:boolean)
    _tag(name, nil, options, open, true)
  end

  def tag(name:String, options:HashMap)
    _tag(name, nil, options, false, true)
  end

  def tag(name:String)
    _tag(name, nil, HashMap.new, false, true)
  end

  def content_tag(name:String, value:String, options:HashMap,
                  open:boolean, escape:boolean)
    _tag(name, value, options, open, escape)
  end

  def content_tag(name:String, value:String, options:HashMap, open:boolean)
    _tag(name, value, options, open, true)
  end

  def content_tag(name:String, value:String, options:HashMap)
    _tag(name, value, options, false, true)
  end

  def content_tag(name:String, value:String)
    _tag(name, value, HashMap.new, false, true)
  end

  def content_tag(name:String)
    _tag(name, "", HashMap.new, false, true)
  end

end
