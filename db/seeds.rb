# frozen_string_literal: true

User.create!(email: "mgielen90@gmail.com", password: "123456", role: 1)
User.create!(email: "anormaluser@gmail.com", password: "123456")

puts "*** admin and normal user created ***"

["Sleep", "Physical health", "Relax", "Connection"].map do |category|
  Category.create!(
    name: category.to_s,
    description: "This is the description of category #{category}",
    image: "https://via.placeholder.com/350"
  )
end

puts "*** categories created ***"

experiments = [
  "Embrace the darkness",
  "No caffeine",
  "Offline mode",
  "Optimize schedule for sleep"
]

experiments.map! do |experiment|
  Experiment.create!(
    name: experiment.to_s,
    description: Faker::Lorem.paragraph,
    image: "https://via.placeholder.com/350",
    category: Category.first,
    objective: "This is the objective of experiment #{experiment}"
  )
end

puts "*** experiments created ***"

3.times do |resource|
  Resource.create!(
    name: "Resource #{resource}",
    source: "https://www.google.com",
    experiment_id: Experiment.where(name: "Embrace the darkness").first.id
  )
end

puts "*** resources created ***"

benefits = [
  "Better sleep",
  "Feeling more rested",
  "More energy during the day"
]

benefits.map! do |benefit|
  Benefit.create!(
    name: benefit.to_s,
    measurement_statement: "This is the measurement statement for #{benefit}"
  )
end

puts "*** benefits created ***"

experiments.each do |experiment|
  experiment.benefits << benefits
end

puts "*** linked benefits to experiments ***"

journal_entry_dates = [DateTime.current, DateTime.yesterday]

journal_entry_dates.map do |date|
  JournalEntry.create!(
    date: date,
    user_id: User.first.id
  )
end

puts "*** journal entries created ***"

journal_statements = [
  "I am in a good mood today", "I slept well and feel rested", "I am feeling healthy",
  "I feel relaxed most of the time", "I feel connected to myself and/or others",
  "My life feels meaningful"
]

journal_statements.map do |statement|
  JournalStatement.create!(
    name: statement.to_s
  )
end

puts "*** journal statements created ***"

journal_rating_scores = [6, 7, 4, 2, 7, 9]

journal_rating_scores.map.with_index do |score, index|
  JournalRating.create!(
    journal_statement_id: JournalStatement.find_by(id: index + 1).id,
    score: score,
    journal_entry_id: JournalEntry.last.id
  )
end

puts "*** journal ratings created ***"
