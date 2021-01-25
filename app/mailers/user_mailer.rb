# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def experiment_start_email
    @user = params[:user]
    @experiment = params[:experiment]
    mail(to: @user.email, subject: "Yay! You just started an experiment")
  end

  def test_mail_marlies
    @user = params[:user]
    mail(to: @user.email, subject: "This is the cron test")
  end
end
