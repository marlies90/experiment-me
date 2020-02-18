FactoryBot.define do
  factory :experiment_user do
    experiment { FactoryBot.build(:experiment) }
    user { FactoryBot.build(:user) }
    starting_date { DateTime.current }
    ending_date { (DateTime.current + 21).end_of_day }

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
