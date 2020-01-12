FactoryBot.define do
  factory :journal_entry do
    date { DateTime.current.beginning_of_day }
    user { FactoryBot.build_stubbed(:user) }

    journal_ratings { FactoryBot.build_list(:journal_rating, 6) }
  end
end
