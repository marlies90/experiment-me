categories = ["Sleep", "Physical health", "Relax", "Connection"].map do |category|
  Category.create!(
    name: "#{category}",
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

experiments.map do |experiment|
  Experiment.create!(
    name: "#{experiment}",
    description: "This is the description of experiment #{experiment}",
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
    experiment_id: Experiment.where(name: "Embrace the darkness")
  )
end

puts "*** resources created ***"

3.times do |benefit|
  Benefit.create!(
    name: "Benefit #{benefit}"
  )
end

puts "*** benefits created ***"
