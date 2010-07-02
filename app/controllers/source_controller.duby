import java.io.File
import java.lang.System
import stdlib.Array
import stdlib.IO


class SourceController < ApplicationController
  def_edb(show, 'views/source/show.html.erb')
  def_edb(list, 'views/source/list.html.erb')

  # GET /source/*
  def doGet(request, response)
    @base = request.getRequestURI
    @base += '/' unless @base.endsWith('/')
    @path = request.getPathInfo || ""
    node = File.new(System.getProperty('user.dir') + @path)
    if node.isDirectory
      @entries = Array.sort(node.listFiles)
      response.getWriter.write(list)
    else
      if @path.matches "^\/public\/.+\.(ico|gif|jpe?g|png)$"
        response.sendRedirect @path.substring(7, @path.length); nil
      else
        @content = node.isFile ? IO.read(node) : 'Sorry, no file'
        response.getWriter.write(show)
      end
    end
  end
end
