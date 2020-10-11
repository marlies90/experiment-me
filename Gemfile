# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.6.3"

# setup
gem "pg", ">= 0.18", "< 2.0"
gem "puma", "~> 3.12"
gem "rails", "~> 6.0.0"

# layout
gem "aws-sdk-s3", require: false
gem "bootstrap", "~> 4.3", ">= 4.3.1"
gem "chartkick", "~> 3.4"
gem "cocoon", "~> 1.2", ">= 1.2.14"
gem "exception_handler", "~> 0.8.0.0"
gem "friendly_id", "~> 5.3"
gem "jquery-rails", "~> 4.3", ">= 4.3.5"
gem "jquery-ui-rails", "~> 6.0", ">= 6.0.1"
gem "sass-rails", "~> 5.0"
gem "simple_form", "~> 5.0", ">= 5.0.1"
gem "uglifier", ">= 1.3.0"

# authentication / authorization
gem "devise", "~> 4.7", ">= 4.7.1"
gem "pundit", "~> 2.1"
gem "pundit-matchers", "~> 1.6"

# code style
gem "rubocop", "~> 0.80.1"

# performance
gem "bootsnap", ">= 1.1.0", require: false
gem "turbolinks", "~> 5"

# security
gem "rack-attack", "~> 6.2", ">= 6.2.2"
gem "sqreen"

# mails
gem "mail_form", "~> 1.8"
gem "sendgrid-ruby", "~> 6.2"

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "pry-rails", "~> 0.3.9"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console", ">= 3.3.0"
end

group :test do
  gem "capybara", "~> 3.30"
  gem "factory_bot_rails"
  gem "faker", "~> 2.10"
  gem "launchy", "~> 2.4", ">= 2.4.3"
  gem "rspec-rails"
  gem "shoulda", "~> 3.6"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
