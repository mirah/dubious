import com.google.appengine.ext.duby.db.Model
import java.util.HashMap
import dubious.Params

class FormHelper
  def initialize(attributes:HashMap, params:Params)
    @a = attributes
    @params = params
    @method = params.action.equals('edit') ? 'put' : 'post'
    @action = params.action.equals('edit') ? params.show : params.index
    @token = '123456'
  end

  def form_for
    return <<EOF
<form action="#{@action}" class="#{@params.action}_" id="#{@params.action}_#{@a.get('kind')}" method="post"><input name="_method" type="hidden" value="#{@method}" /><div style="margin:0;padding:0;display:inline"><input name="authenticity_token" type="hidden" value="#{@token}" /></div>
EOF
  end

  def end
    "</form>"
  end

  def submit(name:String)
    code = name.toLowerCase
    commit = @params.action.equals('edit') ? 'Update' : 'Create'
    return <<EOF
<input id="#{@a.get('kind')}_submit" name="commit" type="submit" value="#{commit}" /> 
EOF
  end

  def error_messages
    "<!-- soon -->"
  end

  def check_box(name:String)
    "<!-- soon -->"
  end

  def fields_for(name:String)
    code = name.toLowerCase
    return <<EOF
<input id="#{@a.get('kind')}_#{code}" name="#{@a.get('kind')}[#{code}]" size="30" type="text" value="#{@a.get(name)}"/> 
EOF
  end

  def file_field(name:String)
    "<!-- soon -->"
  end

  def hidden_field(name:String)
    code = name.toLowerCase
    return <<EOF
<input name="#{@a.get('kind')}_#{code}" type="hidden" value="#{@a.get(name)}"/>
EOF
  end

  def label(name:String)
    code = name.toLowerCase
    return <<EOF
<label for="#{@a.get('kind')}_#{code}">#{name}</label>
EOF
  end

  def password_field(name:String)
    code = name.toLowerCase
    return <<EOF
<input id="#{@a.get('kind')}_#{code}" name="#{@a.get('kind')}[#{code}]" size="30" type="password" value="#{@a.get(name)}"/> 
EOF
  end

  def radio_button(name:String)
    "<!-- soon -->"
  end

  def text_area(name:String)
    code = name.toLowerCase
    return <<EOF
<textarea cols="40" id="#{@a.get('kind')}_#{code}" name="#{@a.get('kind')}[#{code}]" rows="20">#{@a.get(name)}</textarea> 
EOF
  end

  def text_field(name:String)
    code = name.toLowerCase
    return <<EOF
<input id="#{@a.get('kind')}_#{code}" name="#{@a.get('kind')}[#{code}]" size="30" type="text" value="#{@a.get(name)}"/> 
EOF
  end

  def date_select(name:String)
    "<!-- soon -->"
  end

  def time_select(name:String)
    "<!-- soon -->"
  end
end
