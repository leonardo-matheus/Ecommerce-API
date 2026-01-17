# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile
Bundler.require(*Rails.groups)

module EcommerceApi
  class Application < Rails::Application
    # Initialize configuration defaults for Rails 7
    config.load_defaults 7.0

    # API-only mode
    config.api_only = true

    # Timezone
    config.time_zone = 'Brasilia'

    # Locale
    config.i18n.default_locale = 'pt-BR'
    config.i18n.available_locales = %i[en pt-BR]

    # Generators configuration
    config.generators do |g|
      g.test_framework :rspec
      g.factory_bot suffix: 'factory'
    end
  end
end
