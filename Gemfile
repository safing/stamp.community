source 'https://rubygems.org'

# https://github.com/bundler/bundler/issues/4978
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.2.2', '>= 5.2.2.1'
gem 'sidekiq', '>= 5.2.3'
gem 'sidekiq-scheduler', '>= 3.0.0'

gem 'hirb'
gem 'jsonb_accessor'
gem 'pg'

gem 'puma'

gem 'font_awesome5_rails', '>= 0.4.2'
gem 'sassc-rails', '>= 2.1.0'

gem 'jquery-rails', '>= 4.3.3'
gem 'turbolinks'

gem 'haml-rails', '>= 1.0.0'
gem 'redcarpet'

gem 'bootsnap', require: false

gem 'counter_culture'
# WARNING: when updating public_activity
# assert our patch works: models/concerns/public_activity
# and the specs:    specs/models/concerns/public_activity
gem 'devise', '>= 4.7.1'
gem 'public_activity', '>= 1.6.3'
gem 'pundit'
gem 'state_machines-activerecord'

gem 'grape', '>= 1.1.0'
gem 'grape-entity', github: 'ruby-grape/grape-entity', branch: 'master'

group :development do
  gem 'grape_on_rails_routes', '>= 0.3.2'
  gem 'letter_opener'
  gem 'seedbank'
end

group :development, :test do
  gem 'factory_bot_rails', '>= 4.11.1'
  gem 'faker'
  gem 'fix-db-schema-conflicts'
  gem 'pry-byebug'
end

group :test do
  gem 'database_cleaner'
  gem 'guard-rspec'
  gem 'pundit-matchers', '>= 1.6.0'
  gem 'rails-controller-testing', '>= 1.0.4'
  gem 'rspec-rails', '>= 3.8.1'
  gem 'shoulda-matchers', github: 'thoughtbot/shoulda-matchers', branch: 'master'
  gem 'state_machines-rspec'

  gem 'capybara', '>= 3.11.1'
  gem 'fakeredis'
  gem 'launchy'
  gem 'selenium-webdriver'
  # check if the release is out yet https://github.com/thoughtbot/shoulda-matchers/milestone/13
end
