# frozen_string_literal: true

FactoryBot.define do
  factory :experiment_user_measurement do
    benefit { FactoryBot.build(:benefit) }

    trait :with_starting_score do
      starting_score { Faker::Number.between(from: 1, to: 10) }
    end

    trait :complete do
      starting_score { Faker::Number.between(from: 1, to: 10) }
      ending_score { Faker::Number.between(from: 1, to: 10) }
    end
  end
end
