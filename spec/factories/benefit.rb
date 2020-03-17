# frozen_string_literal: true

FactoryBot.define do
  factory :benefit do
    name { Faker::Games::Zelda.item }
    measurement_statement { Faker::Lorem.paragraph }
  end
end
