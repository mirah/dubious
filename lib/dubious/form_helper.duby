import com.google.appengine.ext.duby.db.Model
import java.util.Map
import stdlib.Title
import stdlib.Array
import dubious.Params

class FormHelper
  def initialize(model:Model, params:Params)
    @a = model.properties
    @kind = model.kind.toLowerCase
    @params = params
    @method = params.action.equals('edit') ? 'put' : 'post'
    @action = params.action.equals('edit') ? params.show : params.index
    @token = '123456'
  end

  def start_form
    _method = ["get" ,"post"].contains(@method) ? "" :
        "<input name=\"_method\" type=\"hidden\" value=\"#{@method}\" />"
    return <<EOF
<form action="#{@action}" class="#{@params.action}_" id="#{@params.action}_#{@kind}" method="post">#{_method}<div style="margin:0;padding:0;display:inline"><input name="authenticity_token" type="hidden" value="#{@token}" /></div>
EOF
  end

  def end_form
    "</form>"
  end

  def submit(name:String)
    commit = @params.action.equals('edit') ? 'Update' : 'Create'
    return <<EOF
<input id="#{@kind}_submit" name="commit" type="submit" value="#{commit}" /> 
EOF
  end

  def error_messages
    "<!-- soon -->"
  end

  def check_box(name:String)
    "<!-- soon -->"
  end

  def fields_for(name:String)
    return <<EOF
<input id="#{@kind}_#{name}" name="#{@kind}[#{name}]" size="30" type="text" value="#{@a.get(name) || ""}"/> 
EOF
  end

  def file_field(name:String)
    "<!-- soon -->"
  end

  def hidden_field(name:String)
    return <<EOF
<input name="#{@kind}_#{name}" type="hidden" value="#{@a.get(name) || ""}"/>
EOF
  end

  def label(name:String)
    return <<EOF
<label for="#{@kind}_#{name}">#{Inflections.titleize(name)}</label>
EOF
  end

  def password_field(name:String)
    return <<EOF
<input id="#{@kind}_#{name}" name="#{@kind}[#{name}]" size="30" type="password" value="#{@a.get(name) || ""}"/> 
EOF
  end

  def radio_button(name:String)
    "<!-- soon -->"
  end

  def text_area(name:String)
    return <<EOF
<textarea cols="40" id="#{@kind}_#{name}" name="#{@kind}[#{name}]" rows="20">#{@a.get(name) || ""}</textarea> 
EOF
  end

  def text_field(name:String)
    return <<EOF
<input id="#{@kind}_#{name}" name="#{@kind}[#{name}]" size="30" type="text" value="#{@a.get(name) || ""}"/> 
EOF
  end

  def date_select(name:String)
    "<!-- soon -->"
  end

  def time_select(name:String)
    "<!-- soon -->"
  end
end
