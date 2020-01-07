FactoryBot.define do
  factory :resource do
    name { "The best resource" }
    source { "https://www.google.com" }
  end
end
