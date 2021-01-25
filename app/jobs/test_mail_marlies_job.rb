# frozen_string_literal: true

class TestMailMarliesJob < ActiveJob::Base
  def perform
    UserMailer.with(user: User.find_by(email: "mgielen90@gmail.com")).test_mail_marlies.deliver_later
  end
end
