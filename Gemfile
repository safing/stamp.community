source 'https://rubygems.org'

# https://github.com/bundler/bundler/issues/4978
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.2.1'
gem 'sidekiq'
gem 'sidekiq-scheduler'

gem 'hirb'
gem 'jsonb_accessor'
gem 'pg'

gem 'font_awesome5_rails'
gem 'sass-rails'

gem 'jquery-rails'
gem 'turbolinks'

gem 'haml-rails'
gem 'redcarpet'

gem 'bootsnap', require: false

gem 'counter_culture'
# WARNING: when updating public_activity
# assert our patch works: models/concerns/public_activity
# and the specs:    specs/models/concerns/public_activity
gem 'devise'
gem 'public_activity'
gem 'pundit'
gem 'state_machines-activerecord'

gem 'grape'
gem 'grape-entity', github: 'ruby-grape/grape-entity', branch: 'master'

group :development do
  gem 'fix-db-schema-conflicts'
  gem 'grape_on_rails_routes'
  gem 'letter_opener'
  gem 'seedbank'
end

group :development, :test do
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry-byebug'
end

group :test do
  gem 'database_cleaner'
  gem 'guard-rspec'
  gem 'pundit-matchers'
  gem 'rspec-rails'
  gem 'shoulda-matchers', github: 'thoughtbot/shoulda-matchers', branch: 'master'
  gem 'state_machines-rspec'

  gem 'capybara'
  gem 'launchy'
  gem 'selenium-webdriver'
  gem 'fakeredis'
  # check if the release is out yet https://github.com/thoughtbot/shoulda-matchers/milestone/13
end
