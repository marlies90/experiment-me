FactoryBot.define do
  factory :experiment do
    name { "Test Experiment" }
    description { "This is a test experiment" }
    image { "sdfsdfs" }
    objective { "To be the very best test there ever was" }
    category { FactoryBot.create(:category) }
  end
end
