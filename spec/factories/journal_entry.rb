FactoryBot.define do
  factory :journal_entry do
    date { "2019-11-26 09:51:49" }
    user { FactoryBot.build_stubbed(:user) }

    factory :journal_entry_with_ratings do
      journal_ratings { FactoryBot.build_list(:journal_rating, 6) }
    end
  end
end
