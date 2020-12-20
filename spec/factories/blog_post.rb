# frozen_string_literal: true

FactoryBot.define do
  factory :blog_post do
    name { Faker::Educator.subject }
    summary { Faker::Lorem.paragraph }
    description { Faker::Lorem.paragraph }
    slug { Faker::Internet.slug }
  end
end
