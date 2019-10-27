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

experiments.map! do |experiment|
  Experiment.create!(
    name: "#{experiment}",
    description: "This is the description of experiment #{experiment}. Doggo ipsum noodle horse borkf big ol pupper, the neighborhood pupper. Borking doggo super chub long water shoob extremely cuuuuuute dat tungg tho h*ck, heck thicc pats. Pupperino pats you are doing me the shock aqua doggo heckin angery woofer, what a nice floof most angery pupper I have ever seen mlem. aqua doggo. extremely cuuuuuute. Length boy shoob vvv clouds aqua doggo, wow such tempt many pats fluffer. Floofs the neighborhood pupper long woofer porgo noodle horse doing me a frighten, thicc puggorino blep. Big ol doge heckin the neighborhood pupper boofers super chub sub woofer, adorable doggo blep fat boi sub woofer pupperino. Long woofer heckin good boys and girls shibe very hand that feed shibe thicc, fat boi very taste wow lotsa pats. heckin angery woofer long bois puggorino. Blep shoob long water shoob, puggorino.
    Boofers super chub shibe extremely cuuuuuute, long water shoob heckin. Noodle horse mlem long doggo vvv, tungg I am bekom fat. Borking doggo tungg wow very biscit pupperino you are doin me a concern I am bekom fat, he made many woofs snoot what a nice floof. Shooberino long water shoob doggorino floofs, shoob. Bork aqua doggo smol clouds borkdrive, length boy porgo. Many pats tungg blep aqua doggo, wow very biscit length boy. doggorino pats heck. Clouds lotsa pats sub woofer such treat, vvv.",
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
    name: "#{benefit}"
  )
end

puts "*** benefits created ***"

experiments.each do |experiment|
  experiment.benefits << benefits
end

puts "*** linked benefits to experiments ***"
