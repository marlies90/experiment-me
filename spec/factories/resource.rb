FactoryBot.define do
  factory :resource do
    name { Faker::Games::Zelda.item }
    source { Faker::Internet.url }
    
    experiment { FactoryBot.build_stubbed(:experiment) }
  end
end
