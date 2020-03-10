FactoryBot.define do
  factory :experiment_user_measurement do
    benefit { FactoryBot.build(:benefit) }
    starting_score { Faker::Number.between(from: 1, to: 10) }
    ending_score { Faker::Number.between(from: 1, to: 10) }
  end
end
