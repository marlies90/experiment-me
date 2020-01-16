FactoryBot.define do
  factory :experiment do
    name { Faker::Superhero.name }
    description { Faker::Lorem.paragraph }
    image { Faker::Avatar.image }
    objective { Faker::Lorem.sentence }

    category { FactoryBot.build(:category) }
    benefits { FactoryBot.build_stubbed_list(:benefit, 2) }
  end
end
