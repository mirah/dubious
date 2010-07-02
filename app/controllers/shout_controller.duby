import com.google.appengine.api.datastore.Text
import com.google.appengine.ext.duby.db.Model
import javax.servlet.ServletConfig
import java.lang.System


class Shout < Model
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
    post = Shout.new
    post.title = request.getParameter('title')
    post.body  = request.getParameter('body')
    post.save
    doGet(request, response)
  end
end
