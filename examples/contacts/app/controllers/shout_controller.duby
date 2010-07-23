import com.google.appengine.api.datastore.Text
import com.google.appengine.ext.duby.db.Model
import java.util.HashMap

class Shout < Model
  property 'title', String
  property 'body',  Text
end

class ShoutController < ApplicationController

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

  def_edb(list_erb, 'views/shout/list.html.erb')
  def_edb(main_erb, 'views/layouts/application.html.erb')
end
