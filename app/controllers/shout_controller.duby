import com.google.appengine.api.datastore.Text
import com.google.appengine.ext.duby.db.Model
import java.util.Collections
import java.util.ArrayList


class Shout < Model
  def initialize; end

  property 'title', String
  property 'body',  Text
end

class ShoutController < ApplicationController
  def_edb(list, 'views/shout/list.html.erb')
  def_edb(main, 'views/layouts/application.html.erb')

  # GET /shout
  def doGet(request, response)
    @shouts = Shout.all.run
    @page_charset = 'UTF-8'
    @page_title   = 'Shout'
    @page_content = list
    response.setContentType("text/html; charset=#{@page_charset}")
    response.getWriter.write(main)
  end

  # POST /shout
  def doPost(request, response)
    shout = Shout.new
    shout.title = request.getParameter('title')
    shout.body  = request.getParameter('body')
    shout.save
    doGet(request, response)
  end
end
