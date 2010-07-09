import dubious.*

class ContactsController < ApplicationController

  # GET /contacts
  def index
    @contacts = Contact.all.run
    render index_erb
  end

  # GET /contacts/1
  def show
    @contact = Contact.get(@params.id)
    render show_erb
  end

  # GET /contacts/new
  def new
    @contact = Contact.new
    render new_erb
  end

  # GET /contacts/1/edit
  def edit
    @contact = Contact.get(@params.id)
    render edit_erb
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
    @params.response.getWriter.write(main_erb)
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
    # Process request
    if @params.action.equals("")
      index
    elsif @params.action.equals('show')
      show
    elsif @params.action.equals('new')
      new
    elsif @params.action.equals('edit')
      edit
    else
      response.sendRedirect("/404.html"); nil # INVALID URL
    end
  end

  # POST /contacts/*
  def doPost(request, response)
    @params = Params.new(request, response)
    @link_to = LinkTo.new(@params)
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

  # render templates
  def_edb(index_erb, 'views/contacts/index.html.erb')
  def_edb(show_erb, 'views/contacts/show.html.erb')
  def_edb(new_erb, 'views/contacts/new.html.erb')
  def_edb(edit_erb, 'views/contacts/edit.html.erb')
  def_edb(main_erb, 'views/layouts/contacts.html.erb')
end
