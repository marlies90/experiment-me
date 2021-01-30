# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def experiment_start_email
    @user = params[:user]
    @experiment = params[:experiment]
    mail(to: @user.email, subject: "Yay! You just started an experiment")
  end

  def experiment_midway_email
    @user = params[:user]
    @experiment = params[:experiment]
    mail(to: @user.email, subject: "You’re halfway through the experiment 💪")
  end

  def experiment_end_email
    @user = params[:user]
    @experiment = params[:experiment]
    @experiment_user = params[:experiment_user]
    mail(to: @user.email, subject: "YES! You’ve completed the experiment 🎉")
  end
end
