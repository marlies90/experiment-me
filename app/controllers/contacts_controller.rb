# frozen_string_literal: true

class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    @contact.request = request
    if @contact.deliver
      flash.now[:error] = nil
      redirect_to contacts_thank_you_path
    else
      flash.now[:error] = "Couldn't send message."
      render :new
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :message, :human, :captcha)
  end
end
