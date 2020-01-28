FactoryBot.define do
  factory :category do
    name { Faker::Educator.subject }
    description { Faker::Lorem.paragraph }
  end
end
