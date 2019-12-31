FactoryBot.define do
  factory :journal_entry do
    date { "2019-11-26 09:51:49" }
    user { FactoryBot.create(:user) }
  end
end
