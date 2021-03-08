# frozen_string_literal: true

FactoryBot.define do
  factory :mail_preference do
    user { FactoryBot.build_stubbed(:user) }
    mail_type { Faker::Number.between(from: 1, to: 3) }
    status { Faker::Number.between(from: 0, to: 1) }
  end
end
