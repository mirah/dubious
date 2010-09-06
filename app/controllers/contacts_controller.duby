import dubious.*
import models.*

class ContactsController < ApplicationController

  # GET /contacts
  def index
    @contacts = Contact.all.run
    render index_erb, main_erb
  end

  # GET /contacts/1
  def show
    @contact = Contact.get(params.id)
    render show_erb, main_erb
  end

  # GET /contacts/new
  def new
    @contact = Contact.new
    render new_erb, main_erb
  end

  # GET /contacts/1/edit
  def edit
    @contact = Contact.get(params.id)
    render edit_erb, main_erb
  end

  # DELETE /contacts/1
  def delete
    Contact.delete(Contact.get(params.id).key)
    redirect_to params.index
  end

  # POST /contacts
  def create
    Contact.new.update(params.for('contact')).save
    redirect_to params.index
  end

  # PUT /contacts/1
  def update
    Contact.get(params.id).update(params.for('contact')).save
    redirect_to params.show
  end

  def doGet(request, response)
    action_response(response, action_request(request, 'get'))
  end

  def doPost(request, response)
    action_response(response, action_request(request, 'post'))
  end

  # render templates
  def_edb(index_erb, 'views/contacts/index.html.erb')
  def_edb(show_erb,  'views/contacts/show.html.erb')
  def_edb(new_erb,   'views/contacts/new.html.erb')
  def_edb(edit_erb,  'views/contacts/edit.html.erb')
  def_edb(main_erb,  'views/layouts/contacts.html.erb')
end
