import dubious.Params
import java.util.HashMap

class LinkTo
  def initialize(params:Params)
    @id = params.id
    @base = params.controller
  end

  def index
    "#{@base}"
  end

  def new
    "#{@base}/new"
  end

  def show
    show(@id)
  end

  def show(id:long)
    "#{@base}/#{String.valueOf(id)}"
  end

  def edit
    edit(@id)
  end

  def edit(id:long)
    "#{@base}/#{String.valueOf(id)}/edit"
  end

  def destroy
    destroy(@id)
  end

  def destroy(id:long)
    token = '123' # TODO
    href = show(id)
    onclick = <<EOF
if (confirm('Are you sure?')) {
var f = document.createElement('form');
f.style.display = 'none';
this.parentNode.appendChild(f);
f.method = 'POST';
f.action = this.href;
var m = document.createElement('input');
m.setAttribute('type', 'hidden');
m.setAttribute('name', '_method');
m.setAttribute('value', 'delete');
f.appendChild(m);
var s = document.createElement('input');
s.setAttribute('type', 'hidden');
s.setAttribute('name', 'authenticity_token');
s.setAttribute('value', '#{token}');
f.appendChild(s);
f.submit(); }; return false;)
EOF
    hm = HashMap.new
    hm.put("href", href)
    hm.put("onclick", onclick.replace("\n"," "))
    hm
  end
end
