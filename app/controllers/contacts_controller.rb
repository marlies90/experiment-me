# frozen_string_literal: true

class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(params[:contact])
    @contact.request = request
    if @contact.deliver
      flash.now[:error] = nil
      redirect_to contacts_path, notice: "Message sent successfully"
    else
      flash.now[:error] = "Something went wrong. Please contact info@experiment.rocks if it happens again."
      render :new
    end
  end
end
