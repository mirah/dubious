import com.google.appengine.ext.duby.db.Model
import dubious.Params


class FormHelper
  def initialize(name:String, action:String)
    @m = name.toLowerCase
    @action = action
    @method = action.equals('edit') ? 'put' : 'post'
    @token = '123456'
  end

  def form_for
    return <<EOF
<form action="/#{@m}" class="#{@action}_" id="#{@action}_#{@m}" method="post"><input name="_method" type="hidden" value="#{@method}" /><div style="margin:0;padding:0;display:inline"><input name="authenticity_token" type="hidden" value="#{@token}" /></div>
EOF
  end

  def end
    "</form>"
  end

  def submit(name:String)
    code = name.toLowerCase
    commit = @action.equals('edit') ? 'Update' : 'Create'
    return <<EOF
<input id="#{@m}_submit" name="commit" type="submit" value="#{commit}" /> 
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
<input id="#{@m}_#{code}" name="#{@m}[#{code}]" size="30" type="text" /> 
EOF
  end

  def file_field(name:String)
    "<!-- soon -->"
  end

  def hidden_field(name:String)
    code = name.toLowerCase
    return <<EOF
<input name="#{@m}_#{code}" type="hidden" />
EOF
  end

  def label(name:String)
    code = name.toLowerCase
    return <<EOF
<label for="#{@m}_#{code}">#{name}</label>
EOF
  end

  def password_field(name:String)
    code = name.toLowerCase
    return <<EOF
<input id="#{@m}_#{code}" name="#{@m}[#{code}]" size="30" type="password" /> 
EOF
  end

  def radio_button(name:String)
    "<!-- soon -->"
  end

  def text_area(name:String)
    code = name.toLowerCase
    return <<EOF
<textarea cols="40" id="#{@m}_#{code}" name="#{@m}[#{code}]" rows="20"></textarea> 
EOF
  end

  def text_field(name:String)
    code = name.toLowerCase
    return <<EOF
<input id="#{@m}_#{code}" name="#{@m}[#{code}]" size="30" type="text" /> 
EOF
  end

  def date_select(name:String)
    "<!-- soon -->"
  end

  def time_select(name:String)
    "<!-- soon -->"
  end
end
