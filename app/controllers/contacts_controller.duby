import com.google.appengine.api.datastore.Key
import com.google.appengine.api.datastore.Text
import com.google.appengine.api.datastore.Link
import com.google.appengine.api.datastore.PostalAddress
import com.google.appengine.api.datastore.PhoneNumber
import com.google.appengine.ext.duby.db.Model
import javax.servlet.http.HttpServletRequest
import dubious.Params
import dubious.FormHelper


class Contact < Model
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
  def_edb(_main, 'views/layouts/application.html.erb')

  # GET /contacts
  def index
    @contacts = Contact.all.run
    @page_content = _index
  end

  # GET /contacts/1
  def show(key:Key)
    @contact = Contact.get(key)
    @page_content = _show
  end

  # GET /contacts/new
  def new
    @contact = Contact.new
    @page_content = _new
  end

  # GET /contacts/1/edit
  def edit(key:Key)
    @contact = Contact.get(key)
    @page_content = _edit
  end

  # GET /contacts/*
  def doGet(request, response)
    params = Params.new(request, 'key/action')
    @method = request.getParameter('_method') || 'get'
    invalid_action_url = "/404.html"
    @page_title   = 'Contacts'
    @page_charset = 'UTF-8'
    response.setContentType("text/html; charset=#{@page_charset}")
    if params.action.nil? and params.key.nil?
      index
      response.getWriter.write(_main)
    elsif params.action.nil? and params.key
      show(params.key)
      response.getWriter.write(_main)
    elsif params.action.equals('new')
      new
      response.getWriter.write(_main)
    elsif params.action.equals('edit') and params.key
      edit(params.key)
      response.getWriter.write(_main)
    else
      response.sendRedirect(invalid_action_url); nil
    end      
  end

  # POST /contacts/*
  def doPost(request, response)
    params = Params.new(request, 'key/action')
    @method = request.getParameter('_method') || 'post'
    invalid_token_url = "/422.html"
    contacts_url      = "#{params.controller}"
    contacts_id_url   = "#{contacts_url}/#{params.key_to_s}"
    # Process request
    if invalid_authenticity_token request.getParameter('authenticity_token')
      response.sendRedirect(invalid_token_url); nil
    elsif @method.equals('delete')
      # DELETE /contacts/1
#     Contact.delete(params.key) # TODO: fix return type
      response.sendRedirect(contacts_url); nil
    elsif @method.equals('post')
      # POST /contacts
      update_attributes request, Contact.new
      response.sendRedirect(contacts_id_url); nil
    elsif @method.equals('put')
      # PUT /contacts/1
      update_attributes request, Contact.get(params.key)
      response.sendRedirect(contacts_id_url); nil
    end
  end

  def update_attributes(request:HttpServletRequest, entity:Contact)
    returns :void
    entity.title   = request.getParameter('title')   || ""
    entity.summary = request.getParameter('summary') || ""
    entity.url     = request.getParameter('url')     || nil
    entity.address = request.getParameter('address') || ""
    entity.phone   = request.getParameter('phone')   || ""
    entity.save
  end

  def invalid_authenticity_token(token:String) # TODO
    token.equals("") ? true : false 
  end
end
