import javax.servlet.http.*
import dubious.* # Params LinkTo


class ContactsController < ApplicationController

  # GET /contacts
  def index
    @contacts = Contact.all.run
    render _index
  end

  # GET /contacts/1
  def show
    @contact = Contact.get(@params.id)
    render _show
  end

  # GET /contacts/new
  def new
    @contact = Contact.new
    render _new
  end

  # GET /contacts/1/edit
  def edit
    @contact = Contact.get(@params.id)
    render _edit
  end

  # DELETE /contacts/1
  def delete
    Contact.delete(Contact.get(@params.id).key)
    redirect_to @link_to.index
  end

  # POST /contacts
  def create
    Contact.new.update_attributes(@params)
    redirect_to @link_to.index
  end

  # PUT /contacts/1
  def update
    Contact.get(@params.id).update_attributes(@params)
    redirect_to @link_to.show
  end


  ### move to parent ###


  def render(content:String)
    @page_content = content
    @params.response.getWriter.write(_main)
  end

  def redirect_to(link:String)
    @params.response.sendRedirect(link); nil
  end

  # GET /contacts/*
  def doGet(request, response)
    @params = Params.new(request, response)
    @link_to = LinkTo.new(@params)
    @flash_notice = ""
    response.setContentType("text/html; charset=UTF-8")
    invalid_action_url = "/404.html"
    # Process request
    if @params.action.nil?
      index
    elsif @params.action.equals('show')
      show
    elsif @params.action.equals('new')
      new
    elsif @params.action.equals('edit')
      edit
    else
      response.sendRedirect(invalid_action_url); nil
    end
  end

  # POST /contacts/*
  def doPost(request, response)
    @params = Params.new(request, response)
    @method = request.getParameter('_method') || 'post'
    # Process request
    if invalid_authenticity_token request.getParameter('authenticity_token')
      response.sendRedirect("/422.html"); nil # INVALID TOKEN
    elsif @method.equals('delete')
      delete
    elsif @method.equals('post')
      create
    elsif @method.equals('put')
      update
    end
  end

  def invalid_authenticity_token(token:String) # TODO
    token.equals("") ? true : false 
  end

  # render templates to _keys
  def_edb(_index, 'views/contacts/index.html.erb')
  def_edb(_show, 'views/contacts/show.html.erb')
  def_edb(_new, 'views/contacts/new.html.erb')
  def_edb(_edit, 'views/contacts/edit.html.erb')
  def_edb(_main, 'views/layouts/contacts.html.erb')
end
