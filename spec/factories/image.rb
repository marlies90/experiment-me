# frozen_string_literal: true

FactoryBot.define do
  factory :image do
    name { Faker::Educator.subject }
    alt { Faker::Lorem.paragraph }
  end
end
