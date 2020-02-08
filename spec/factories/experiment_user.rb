FactoryBot.define do
  factory :experiment_user do
    experiment { FactoryBot.build(:experiment) }
    user { FactoryBot.build(:user) }

    trait :active do
      status { 0 }
    end

    trait :completed do
      status { 1 }
    end

    trait :cancelled do
      status { 2 }
    end
  end
end
