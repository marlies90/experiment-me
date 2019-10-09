4.times do |category|
  Category.create!(
    name: "Category #{category}",
    description: "This is the description of category #{category}",
    image: "https://via.placeholder.com/350"
  )
end

puts "*** 4 categories created ***"

6.times do |topic|
  Experiment.create!(
    name: "Experiment #{topic}",
    description: "This is the description of experiment #{topic}",
    image: "https://via.placeholder.com/350",
    category: Category.find(topic + 1)
  )
end

puts "*** 6 experiments created ***"

3.times do |resource|
  Resource.create!(
    name: "Resource #{resource}",
    source: "https://www.google.com",
    experiment_id: Experiment.find(resource + 1)
  )
end

puts "*** 3 resources created ***"
