# frozen_string_literal: true

FactoryBot.define do
  factory :mail_preference do
    user { FactoryBot.build_stubbed(:user) }
    status { Faker::Number.between(from: 0, to: 1) }

    trait :experiment_start do
      mail_type { "experiment_start" }
    end

    trait :experiment_midway do
      mail_type { "experiment_midway" }
    end

    trait :experiment_end do
      mail_type { "experiment_end" }
    end
  end
end
