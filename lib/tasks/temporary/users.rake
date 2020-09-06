# frozen_string_literal: true

namespace :users do
  desc "Update existing users to have a confirmed mail address"
  task confirm_users: :environment do
    users = User.where(confirmed_at: nil, terms_agreement: true)
    puts "Going to update #{users.count} users"

    ActiveRecord::Base.transaction do
      users.each do |user|
        user.confirmed_at = DateTime.current
        user.save!
        print "."
      end
    end

    puts " All done now!"
  end
end
