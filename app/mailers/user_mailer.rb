class UserMailer < ApplicationMailer
  def experiment_start_email
    @user = params[:user]
    @experiment  = params[:experiment]
    mail(to: @user.email, subject: "Yay! You just started an experiment")
  end
end
