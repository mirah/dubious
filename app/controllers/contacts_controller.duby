import com.google.appengine.api.datastore.Key
import com.google.appengine.api.datastore.Text
import com.google.appengine.api.datastore.Link
import com.google.appengine.api.datastore.PostalAddress
import com.google.appengine.api.datastore.PhoneNumber
import com.google.appengine.ext.duby.db.Model
import javax.servlet.http.HttpServletRequest
import dubious.Params
import dubious.FormHelper
import com.google.appengine.api.datastore.Key
import com.google.appengine.api.datastore.KeyFactory


class Contact < Model
# property 'id',      Long
# property 'key',     Key
  property 'title',   String
  property 'summary', Text
  property 'url',     Link
  property 'address', PostalAddress
  property 'phone',   PhoneNumber
end

class ContactsController < ApplicationController
  def_edb(_index, 'views/contacts/index.html.erb')
  def_edb(_show, 'views/contacts/show.html.erb')
  def_edb(_new, 'views/contacts/new.html.erb')
  def_edb(_edit, 'views/contacts/edit.html.erb')
  def_edb(_main, 'views/layouts/contacts.html.erb')

  # GET /contacts/*
  def doGet(request, response)
    @params = Params.new(request, 'key/action')
    @method = request.getParameter('_method') || 'get'
    invalid_action_url = "/404.html"
    @flash_notice = ""
    @page_charset = 'UTF-8'
    response.setContentType("text/html; charset=#{@page_charset}")
    if @params.action.nil? and @params.key.nil?
      # GET /contacts
      @action_name = 'index'
      @contacts = Contact.all.run
      @page_content = _index
      response.getWriter.write(_main)
    elsif @params.action.nil? and @params.key
      # GET /contacts/1
      @action_name = 'show'
      @contact = Contact.get(@params.key)
      @page_content = _show
      response.getWriter.write(_main)
    elsif @params.action.equals('new')
      # GET /contacts/new
      @action_name = 'new'
      @contact = Contact.new
      @page_content = _new
      response.getWriter.write(_main)
    elsif @params.action.equals('edit') and @params.key
      # GET /contacts/1/edit
      @action_name = 'edit'
      @contact = Contact.get(@params.key)
      @page_content = _edit
      response.getWriter.write(_main)
    else
      response.sendRedirect(invalid_action_url); nil
    end      
  end

  # POST /contacts/*
  def doPost(request, response)
    @params = Params.new(request, 'key/action')
    @method = request.getParameter('_method') || 'post'
    invalid_token_url = "/422.html"
    # Process request
    if invalid_authenticity_token request.getParameter('authenticity_token')
      response.sendRedirect(invalid_token_url); nil
    elsif @method.equals('delete')
      # DELETE /contacts/1
#     Contact.delete(@params.key) # TODO: fix return type
      response.sendRedirect(@params.controller); nil
    elsif @method.equals('post')
      # POST /contacts
      update_attributes request, Contact.new
      response.sendRedirect(@params.controller); nil
    elsif @method.equals('put')
      # PUT /contacts/1
      update_attributes request, Contact.get(@params.key)
      response.sendRedirect(@params.key_to_s); nil
    end
  end

  def update_attributes(request:HttpServletRequest, entity:Contact)
    returns :void
    entity.title   = request.getParameter('contact[title]')   || ""
    entity.summary = request.getParameter('contact[summary]') || ""
    entity.url     = request.getParameter('contact[url]')     || ""
    entity.address = request.getParameter('contact[address]') || ""
    entity.phone   = request.getParameter('contact[phone]')   || ""
    entity.save
  end

  def invalid_authenticity_token(token:String) # TODO
    token.equals("") ? true : false 
  end
end
