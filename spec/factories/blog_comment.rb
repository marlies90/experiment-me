# frozen_string_literal: true

FactoryBot.define do
  factory :blog_comment do
    author_name { Faker::Name.first_name }
    email { Faker::Internet.email }
    comment { Faker::Lorem.paragraph }
  end

  trait :on_blog_post do
    association :commentable, factory: :blog_post
  end

  trait :on_comment do
    association :commentable, factory: :comment
  end
end
