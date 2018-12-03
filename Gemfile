source 'https://rubygems.org'

# https://github.com/bundler/bundler/issues/4978
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.2.1'
gem 'sidekiq'

gem 'jsonb_accessor'
gem 'pg'
gem 'hirb'

gem 'font_awesome5_rails'
gem 'sass-rails'
gem 'semantic-ui-sass'

gem 'haml-rails'
gem 'jbuilder'
gem 'jquery-rails'
gem 'turbolinks'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc'

gem 'bootsnap', require: false

gem 'devise'
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
  gem 'puma'
end

group :test do
  gem 'database_cleaner'
  gem 'guard-rspec'
  gem 'pundit-matchers'
  gem 'rspec-activemodel-mocks'
  gem 'rspec-rails'
  gem 'shoulda-matchers', github: 'thoughtbot/shoulda-matchers', branch: 'master'
  gem 'state_machines-rspec'

  gem 'capybara'
  gem 'launchy'
  gem 'selenium-webdriver'
  # check if the release is out yet https://github.com/thoughtbot/shoulda-matchers/milestone/13
end
