# frozen_string_literal: true

FactoryBot.define do
  factory :journal_statement do
    name { "This is a statement for you to rate" }
    category { "Category" }
  end
end
