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

  def delete
    delete(@id)
  end

  def delete(confirm:String)
    delete(@id, confirm)
  end

  def delete(id:long)
    delete(id, "Are you sure?")
  end

  def delete(id:long, confirm:String)
    hm = HashMap.new
    hm.put("href", show(id))
    hm.put("data-confirm", confirm)
    hm.put("data-method", "delete")
    hm.put("rel", "nofollow")
    hm
  end
end
