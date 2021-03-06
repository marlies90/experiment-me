# frozen_string_literal: true

FactoryBot.define do
  factory :blog_post do
    name { Faker::Educator.subject }
    summary { Faker::Lorem.paragraph }
    description { Faker::Lorem.paragraph }
    slug { Faker::Internet.slug }
    publish_date { Date.current - 1 }
    meta_title { Faker::Educator.subject }
    meta_description { Faker::Lorem.paragraph }
  end

  trait :with_comments do
    after(:build) do |blog_post|
      FactoryBot.create_list(:blog_comment, 1, commentable: blog_post)
    end
  end
end
