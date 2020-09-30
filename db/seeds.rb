# frozen_string_literal: true

User.create!(
  email: "mgielen90@gmail.com",
  password: "123456",
  first_name: "Marlies",
  time_zone: "UTC",
  terms_agreement: true,
  role: 1
)

User.create!(
  email: "anormaluser@gmail.com",
  password: "123456",
  first_name: "Iamnormal",
  time_zone: "UTC",
  terms_agreement: true
)

puts "*** admin and normal user created ***"

["Sleep", "Physical health", "Relax", "Connection"].map do |category|
  Category.create!(
    name: category.to_s,
    description: "This is the description of category #{category}"
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
    user_id: User.first.id,
    mood: Faker::Number.between(from: 1, to: 5),
    sleep: Faker::Number.between(from: 1, to: 5),
    health: Faker::Number.between(from: 1, to: 5),
    relax: Faker::Number.between(from: 1, to: 5),
    connect: Faker::Number.between(from: 1, to: 5),
    meaning: Faker::Number.between(from: 1, to: 5)
  )
end

puts "*** journal entries created ***"
