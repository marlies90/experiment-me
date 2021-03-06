# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    name { Faker::Educator.subject }
    description { Faker::Lorem.paragraph }
    slug { Faker::Internet.slug }
  end
end
