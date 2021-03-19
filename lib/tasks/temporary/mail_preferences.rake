# frozen_string_literal: true

namespace :mail_preferences do
  desc "Add mail_preferences to existing users"
  task set_mail_preferences_users: :environment do
    users = User.all
    puts "Going to update #{users.count} users"

    ActiveRecord::Base.transaction do
      users.each do |user|
        MailPreference.mail_types.each_key do |mail_type|
          user.mail_preferences.create(
            mail_type: mail_type,
            status: :active
          )
        end

        user.save
        print "."
      end
    end

    puts " All done now!"
  end
end
