FactoryBot.define do
  factory :user do
    first_name {"test"}
    email { "test@test.com" }
    password { "123456" }
    role { 0 }

    trait :admin do
      role { 1 }
    end
  end
end
