require File.expand_path('boot', __dir__)

# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'

require_relative 'setup'
Setup.initialize_settings

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module StampCommunity
  class Application < Rails::Application
    config.load_defaults 5.1

    config.generators do |g|
      g.test_framework  :rspec
      g.javascripts     false
      g.stylesheets     false
      # hackish: instead of creating a helper, create a policy
      #          but we do not need the helper anyway
      g.helper          :policy
    end

    console do
      require 'hirb'
      Hirb.enable
    end
  end
end
