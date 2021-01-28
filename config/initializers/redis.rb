uri = ENV["REDISTOGO_URL"] ? URI.parse(ENV["REDISTOGO_URL"]) : "redis://localhost:6379/"
REDIS = Redis.new(:url => uri)

Redis.exists_returns_integer = true
