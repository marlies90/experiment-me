# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    time_zone { "UTC" }
    role { 0 }
    terms_agreement { true }

    before(:create, &:skip_confirmation!)

    trait :admin do
      role { 1 }
    end
  end
end
