require "sidekiq"
Dir[Rails.root.join("app", "jobs", "*.rb")].each { |f| require f }

Sidekiq.configure_server do |config|
  config.redis = { url: ENV["REDISTOGO_URL"] }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV["REDISTOGO_URL"] }
end

schedule_file = "config/schedule.yml"

if File.exists?(schedule_file)
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end
