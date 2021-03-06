# frozen_string_literal: true

FactoryBot.define do
  factory :observation do
    date { DateTime.current.beginning_of_day }
    user { FactoryBot.build_stubbed(:user) }
    mood { Faker::Number.between(from: 1, to: 5) }
    health { Faker::Number.between(from: 1, to: 5) }
    sleep { Faker::Number.between(from: 1, to: 5) }
    relax { Faker::Number.between(from: 1, to: 5) }
    connect { Faker::Number.between(from: 1, to: 5) }
    meaning { Faker::Number.between(from: 1, to: 5) }
    note { Faker::Lorem.paragraph }
  end
end
