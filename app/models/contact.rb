# frozen_string_literal: true

class Contact < MailForm::Base
  attribute :name, validate: true
  attribute :email,     validate: /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :message,   validate: true
  attribute :human, captcha: true

  def headers
    {
      subject: "New contact form message",
      to: "info@experiment.rocks",
      from: %("#{name}" <#{email}>)
    }
  end
end
