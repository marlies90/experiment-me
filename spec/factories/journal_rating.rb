FactoryBot.define do
  factory :journal_rating do
    journal_statement { FactoryBot.create(:journal_statement) }
    score { 7 }
  end
end
