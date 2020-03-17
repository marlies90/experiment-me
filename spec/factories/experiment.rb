# frozen_string_literal: true

FactoryBot.define do
  factory :experiment do
    name { Faker::Superhero.name }
    description { Faker::Lorem.paragraph }
    objective { Faker::Lorem.sentence }
    slug { Faker::Internet.slug }

    category { FactoryBot.build(:category) }
    benefits { FactoryBot.build_list(:benefit, 2) }
  end
end
