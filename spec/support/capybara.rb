require 'capybara/rails'
require 'capybara/rspec'

Capybara.server = :puma
Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, browser: :firefox, marionette: true)
end

Capybara.javascript_driver = :selenium

RSpec.configure do |config|
  config.include Capybara::DSL
end
