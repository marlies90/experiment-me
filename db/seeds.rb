6.times do |topic|
  Experiment.create!(
    name: "Experiment #{topic}",
    description: "This is the description of experiment #{topic}",
    image: "https://via.placeholder.com/350"
  )
end

puts "6 experiments created"
