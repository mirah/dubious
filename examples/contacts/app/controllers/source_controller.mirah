import java.lang.System
import java.io.File
import stdlib.Array
import stdlib.Io

class SourceController < ApplicationController

  # GET /source/*
  def doGet(request, response)
    @base = request.getRequestURI
    @base += '/' unless @base.endsWith('/')
  # @path = request.getPathInfo || "" # (index).html added
    @path = @base.substring(7, @base.length - 1)
    node = File.new(System.getProperty('user.dir') + @path)
    if node.isDirectory
      @entries = Array.sort(node.listFiles)
      response.getWriter.write(list_erb)
    else
      if @path.matches "^\/public\/.+\.(ico|gif|jpe?g|png)$"
        response.sendRedirect @path.substring(7, @path.length); nil
      else
        @content = node.isFile ? Io.read(node) : 'Sorry, no file'
        response.getWriter.write(show_erb)
      end
    end
  end

  def_edb(show_erb, 'views/source/show.html.erb')
  def_edb(list_erb, 'views/source/list.html.erb')
end
