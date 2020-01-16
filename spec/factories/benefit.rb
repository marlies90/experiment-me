FactoryBot.define do
  factory :benefit do
    name { Faker::Games::Zelda.item }
  end
end
