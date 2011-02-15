import com.google.appengine.api.datastore.Text
import com.google.appengine.ext.mirah.db.Model
import com.google.appengine.api.datastore.*
import java.util.HashMap
import dubious.*
import models.*

class Shout < Model
  property 'title', String
  property 'body',  Text
end

class ShoutController < ActionController

  # GET /shout
  def doGet(request, response)
    @shouts = Shout.all.run
    @page_title   = 'Shout'
    @page_content = list_erb
    response.setContentType("text/html; charset=UTF-8")
    response.getWriter.write(main_erb)
  end

  # POST /shout
  def doPost(request, response)
    shout = Shout.new
    shout.title = request.getParameter('title')
    shout.body  = request.getParameter('body')
    shout.save
    doGet(request, response)
  end

  def_edb(list_erb, 'views/list.html.erb')
  def_edb(main_erb, 'views/application.html.erb')
end
