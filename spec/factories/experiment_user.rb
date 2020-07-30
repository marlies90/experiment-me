# frozen_string_literal: true

FactoryBot.define do
  factory :experiment_user do
    experiment { FactoryBot.build(:experiment) }
    user { FactoryBot.build(:user) }
    starting_date { (DateTime.current - 1).beginning_of_day }
    ending_date { (DateTime.current + 20).end_of_day }

    trait :active do
      status { 0 }
      experiment_user_measurements do
        FactoryBot.build_list(:experiment_user_measurement, 2, :with_starting_score)
      end
    end

    trait :completing do
      status { 0 }
      experiment_user_measurements do
        FactoryBot.build_list(:experiment_user_measurement, 2, :with_starting_score)
      end
    end

    trait :completed do
      status { 1 }
      experiment_user_measurements do
        FactoryBot.build_list(:experiment_user_measurement, 2, :complete)
      end
      difficulty { Faker::Number.between(from: 0, to: 4) }
      life_impact { Faker::Number.between(from: 0, to: 5) }
      ending_note { Faker::Lorem.paragraph }
    end

    trait :cancelling do
      status { 0 }
      experiment_user_measurements do
        FactoryBot.build_list(:experiment_user_measurement, 2, :with_starting_score)
      end
    end

    trait :cancelled do
      status { 2 }
      cancellation_reason { 2 }
    end
  end
end
