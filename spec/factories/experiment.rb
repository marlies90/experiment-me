FactoryBot.define do
  factory :experiment do
    name { Faker::Superhero.name }
    description { Faker::Lorem.paragraph }
    objective { Faker::Lorem.sentence }

    category { FactoryBot.build(:category) }
    benefits { FactoryBot.build_list(:benefit, 2) }
  end
end
